-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Backend.Scalar exposing (Codecs, Date(..), defaultCodecs, defineCodecs, unwrapCodecs, unwrapEncoder)

import Graphql.Codec exposing (Codec)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


type Date
    = Date String


defineCodecs :
    { codecDate : Codec valueDate }
    -> Codecs valueDate
defineCodecs definitions =
    Codecs definitions


unwrapCodecs :
    Codecs valueDate
    -> { codecDate : Codec valueDate }
unwrapCodecs (Codecs unwrappedCodecs) =
    unwrappedCodecs


unwrapEncoder :
    (RawCodecs valueDate -> Codec getterValue)
    -> Codecs valueDate
    -> getterValue
    -> Graphql.Internal.Encode.Value
unwrapEncoder getter (Codecs unwrappedCodecs) =
    (unwrappedCodecs |> getter |> .encoder) >> Graphql.Internal.Encode.fromJson


type Codecs valueDate
    = Codecs (RawCodecs valueDate)


type alias RawCodecs valueDate =
    { codecDate : Codec valueDate }


defaultCodecs : RawCodecs Date
defaultCodecs =
    { codecDate =
        { encoder = \(Date raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map Date
        }
    }
