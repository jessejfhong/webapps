port module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Url exposing (Url)


port requestSesssionToken : () -> Cmd msg


port sessionTokenReceiver : (String -> msg) -> Sub msg


type alias Model =
    { message : String
    , key : Key
    , origin : String
    }


type Msg
    = OnUrlChanged Url
    | OnUrlRequested UrlRequest
    | OnButtonClick
    | GotHelloMsg (Result Http.Error String)
    | GotSessionToken String


init : String -> Url -> Key -> ( Model, Cmd Msg )
init origin url key =
    ( Model "Hello" key origin, Cmd.none )


view : Model -> Document Msg
view model =
    let
        body =
            [ div []
                [ button [ onClick OnButtonClick ] [ text "+" ]
                , div [] [ text model.message ]
                , button [ onClick OnButtonClick ] [ text "-" ]
                ]
            ]
    in
    { title = "Shopify"
    , body = body
    }


hello origin =
    Http.get
        { url = String.concat [ origin, "/api/Home" ]
        , expect = Http.expectString GotHelloMsg
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

        OnButtonClick ->
            ( model, Cmd.batch [ hello model.origin, requestSesssionToken () ] )

        GotHelloMsg result ->
            case result of
                Ok helloMsg ->
                    ( { model | message = helloMsg }, Cmd.none )

                Err _ ->
                    ( { model | message = "Shit happens" }, Cmd.none )

        GotSessionToken token ->
            ( model, Cmd.none )


main : Program String Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> sessionTokenReceiver GotSessionToken
        , onUrlRequest = OnUrlRequested
        , onUrlChange = OnUrlChanged
        }
