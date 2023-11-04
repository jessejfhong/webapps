port module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Events exposing (onKeyPress)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, button, div, h2, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Url exposing (Url)


port requestJsonValue : Int -> Cmd msg


port stringValue : (String -> msg) -> Sub msg


port jsonValue : (Value -> msg) -> Sub msg


type alias User =
    { id : Int
    , name : String
    , gender : Bool
    }


type alias Product =
    { id : Int
    , name : String
    , price : Float
    , quantity : Int
    }


userDecoder : Decoder User
userDecoder =
    Decode.map3 User
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "gender" Decode.bool)


productDecoder : Decoder Product
productDecoder =
    Decode.map4 Product
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "price" Decode.float)
        (Decode.field "quantity" Decode.int)


type alias Model =
    { message : String
    , count : Int
    , key : Key
    , origin : String
    }


type Msg
    = OnUrlChanged Url
    | OnUrlRequested UrlRequest
    | OnButtonClick Int
    | GotStringValue String
    | KeyPressed
    | GotUser (Result Decode.Error User)
    | GotProduct (Result Decode.Error Product)


init : String -> Url -> Key -> ( Model, Cmd Msg )
init origin url key =
    ( Model "Hello" 0 key origin, Cmd.none )


view : Model -> Document Msg
view model =
    let
        buttonClass =
            [ "bg-blue-500", "hover:bg-blue-700", "text-white", "font-blod", "py-2", "px-3", "rounded" ]
                |> List.map class

        body =
            [ div []
                [ h2 [ class "text-3xl", class "font-bold" ] [ text "Elm playground" ]
                , button ([ OnButtonClick 1 |> onClick ] ++ buttonClass) [ text "+" ]
                , div [] [ String.fromInt model.count |> text ]
                , button ([ OnButtonClick 2 |> onClick ] ++ buttonClass) [ text "-" ]
                , p [] [ text model.message ]
                ]
            ]
    in
    { title = "Elm playground"
    , body = body
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlRequested urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                External url ->
                    ( model, Nav.load url )

        OnUrlChanged url ->
            ( model, Cmd.none )

        OnButtonClick flag ->
            ( model, Cmd.batch [ requestJsonValue flag ] )

        GotStringValue token ->
            ( { model | message = token }, Cmd.none )

        KeyPressed ->
            ( { model | count = model.count + 1 }, Cmd.none )

        GotUser value ->
            case value of
                Ok user ->
                    ( { model | message = user.name }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        GotProduct value ->
            case value of
                Ok product ->
                    ( { model | message = product.name }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ stringValue GotStringValue
        , onKeyPress (Decode.succeed KeyPressed)
        , jsonValue (Decode.decodeValue userDecoder >> GotUser)
        , jsonValue (Decode.decodeValue productDecoder >> GotProduct)
        ]


main : Program String Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = OnUrlRequested
        , onUrlChange = OnUrlChanged
        }
