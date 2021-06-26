module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Api.User exposing (User)
import Components.Navbar
import Css
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Json.Decode as Json
import Ports
import Request exposing (Request)
import Utils.Route
import View exposing (View)



-- INIT


type alias Flags =
    Json.Value


type alias Model =
    { user : Maybe User
    }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ json =
    let
        user =
            json
                |> Json.decodeValue Api.User.decoder
                |> Result.toMaybe
    in
    ( Model user
    , Cmd.none
    )



-- UPDATE


type Msg
    = ClickedSignOut
    | SignedInUser User


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        SignedInUser user ->
            ( { model | user = Just user }
            , Ports.saveUser user
            )

        ClickedSignOut ->
            ( { model | user = Nothing }
            , Ports.clearUser
            )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none



-- VIEW


view :
    Request
    -> { page : View msg, toMsg : Msg -> msg }
    -> Model
    -> View msg
view req { page, toMsg } model =
    { title =
        if String.isEmpty page.title then
            "VatCalc"

        else
            page.title ++ " | VatCalc"
    , body =
        [ div
            [ Attr.css [ Css.margin <| Css.px 0 ] ]
            [ Components.Navbar.view
                { user = model.user
                , currentRoute = Utils.Route.fromUrl req.url
                , onSignOut = toMsg ClickedSignOut
                }
            , div
                [ Attr.class "page" ]
                page.body
            ]
        ]
    }
