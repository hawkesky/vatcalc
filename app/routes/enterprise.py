from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from starlette.responses import JSONResponse
from starlette.status import HTTP_201_CREATED, HTTP_409_CONFLICT

from .. import models, validators
from .auth import CurrentUser, current_user_responses
from .utils import (
    Message,
)


def get_enterprise_router():
    enterprise_router = APIRouter(tags=["Enterprise"])

    class EnterpriseResponse(BaseModel):
        enterprise_id: int
        name: str
        role: models.UserEnterpriseRoles
        nip_number: validators.NipNumber
        address: str

    class EnterpriseCreateInput(BaseModel):
        nip_number: validators.NipNumber
        name: str
        address: str

    class EnterpriseCreateResponse(BaseModel):
        id: int
        nip_number: validators.NipNumber
        name: str
        address: str

    class EnterpriseUpdateResponse(BaseModel):
        name: Optional[str]
        address: Optional[str]
        nip_number: Optional[validators.NipNumber]

    @enterprise_router.get(
        "/enterprise",
        response_model=List[EnterpriseResponse],
        responses={**current_user_responses()},
    )
    async def get_user_enterprises(
        page: int, user: models.User = Depends(CurrentUser())
    ):
        enterprises = (
            await models.UserEnterprise.objects.filter(user_id=user.id)
            .select_related("enterprise_id")
            .all()
        )
        enterprises_formatted = [
            EnterpriseResponse(
                enterprise_id=enterprise.enterprise_id.id,
                name=enterprise.enterprise_id.name,
                role=enterprise.role,
                nip_number=enterprise.enterprise_id.nip_number,
                address=enterprise.enterprise_id.address,
            )
            for enterprise in enterprises
        ]

        return enterprises_formatted

    @enterprise_router.post(
        "/enterprise",
        response_model=EnterpriseCreateResponse,
        status_code=HTTP_201_CREATED,
        responses={
            **current_user_responses(),
            HTTP_409_CONFLICT: {"model": Message},
        },
    )
    async def create_enterprise(
        enterprise: EnterpriseCreateInput,
        user: models.User = Depends(CurrentUser()),
    ):
        existing_enterprise = await (
            models.UserEnterprise.objects.select_related(
                [models.UserEnterprise.enterprise_id]
            ).all(
                user_id=user.id,
                enterprise_id__nip_number=enterprise.nip_number,
            )
        )
        if existing_enterprise == []:
            new_enterprise = await models.Enterprise(
                **enterprise.dict(),
            ).save()
            _ = await models.UserEnterprise(
                user_id=user.id,
                enterprise_id=new_enterprise.id,
                role=models.UserEnterpriseRoles.admin.value,
            ).save()
            # Adding standard vatrates
            # for vatrate in [
            #     models.VatRate(
            #         vat_rate=0.23,
            #         comment="Standardowa stawka VAT 23%",
            #         enterprise_id=new_enterprise.id,
            #     ),
            #     models.VatRate(
            #         vat_rate=0.08,
            #         comment="Standardowa stawka VAT 8%",
            #         enterprise_id=new_enterprise.id,
            #     ),
            #     models.VatRate(
            #         vat_rate=0.05,
            #         comment="Standardowa stawka VAT 5%",
            #         enterprise_id=new_enterprise.id,
            #     ),
            #     models.VatRate(
            #         vat_rate=0.0,
            #         comment="Standardowa stawka VAT 0%",
            #         enterprise_id=new_enterprise.id,
            #     ),
            # ]:
            #     await vatrate.save()
            return new_enterprise.dict()

        else:
            return JSONResponse(
                Message(detail="Enterprise exists").json(),
                status_code=HTTP_409_CONFLICT,
            )

    @enterprise_router.patch(
        "/enterprise/{enterprise_id}",
        status_code=200,
        response_model=EnterpriseUpdateResponse,
    )
    async def update_enterprise(
        enterprise_id: int,
        item: EnterpriseUpdateResponse,
        user: models.User = Depends(
            CurrentUser(
                required_permissions=[
                    models.UserEnterpriseRoles.admin,
                ],
            )
        ),
    ):
        enterprise = await (
            models.Enterprise.objects.get_or_none(id=enterprise_id)
        )
        if not enterprise:
            raise HTTPException(
                status_code=404, detail=f"Enterprise {enterprise_id} not found"
            )

        update_data = item.dict(exclude_unset=True)
        await enterprise.update(**update_data)
        enterprise_output = EnterpriseResponse(
            enterprise_id=enterprise.id,
            name=enterprise.name,
            role="ADMIN",
            nip_number=enterprise.nip_number,
            address=enterprise.address,
        )
        return enterprise_output

    @enterprise_router.delete(
        "/enterprise/{enterprise_id}",
        status_code=200,
    )
    async def delete_enterprise(
        enterprise_id: int,
        user: models.User = Depends(
            CurrentUser(
                required_permissions=[
                    models.UserEnterpriseRoles.admin,
                ],
            )
        ),
    ):

        enterprise = await models.Enterprise.objects.get_or_none(
            id=enterprise_id
        )
        if not enterprise:
            raise HTTPException(
                status_code=404, detail=f"Enterprise {enterprise_id} not found"
            )
        await enterprise.delete()
        return JSONResponse({"message": f"Deleted enterprise {enterprise_id}"})

    return enterprise_router
