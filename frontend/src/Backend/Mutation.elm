-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Backend.Mutation exposing (..)

import Backend.InputObject
import Backend.Interface
import Backend.Object
import Backend.Scalar
import Backend.ScalarCodecs
import Backend.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)


type alias CreateTradingPartnerOptionalArguments =
    { adress : OptionalArgument String }


type alias CreateTradingPartnerRequiredArguments =
    { name : String
    , nipNumber : String
    }


createTradingPartner :
    (CreateTradingPartnerOptionalArguments -> CreateTradingPartnerOptionalArguments)
    -> CreateTradingPartnerRequiredArguments
    -> SelectionSet decodesTo Backend.Object.CreateTradingPartner
    -> SelectionSet (Maybe decodesTo) RootMutation
createTradingPartner fillInOptionals____ requiredArgs____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { adress = Absent }

        optionalArgs____ =
            [ Argument.optional "adress" filledInOptionals____.adress Encode.string ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "createTradingPartner" (optionalArgs____ ++ [ Argument.required "name" requiredArgs____.name Encode.string, Argument.required "nipNumber" requiredArgs____.nipNumber Encode.string ]) object____ (identity >> Decode.nullable)


type alias CreateInvoiceRequiredArguments =
    { invoiceInput : Backend.InputObject.InvoiceInput }


createInvoice :
    CreateInvoiceRequiredArguments
    -> SelectionSet decodesTo Backend.Object.CreateInvoice
    -> SelectionSet (Maybe decodesTo) RootMutation
createInvoice requiredArgs____ object____ =
    Object.selectionForCompositeField "createInvoice" [ Argument.required "invoiceInput" requiredArgs____.invoiceInput Backend.InputObject.encodeInvoiceInput ] object____ (identity >> Decode.nullable)
