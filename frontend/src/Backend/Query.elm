-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Backend.Query exposing (..)

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


allPartners :
    SelectionSet decodesTo Backend.Object.TradingPartner
    -> SelectionSet (List decodesTo) RootQuery
allPartners object____ =
    Object.selectionForCompositeField "allPartners" [] object____ (identity >> Decode.list)


allInvoices :
    SelectionSet decodesTo Backend.Object.Invoice
    -> SelectionSet (Maybe (List decodesTo)) RootQuery
allInvoices object____ =
    Object.selectionForCompositeField "allInvoices" [] object____ (identity >> Decode.list >> Decode.nullable)
