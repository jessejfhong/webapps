port module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Events exposing (onKeyPress)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, button, div, h1, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Url exposing (Url)


port requestSesssionToken : () -> Cmd msg


port sessionTokenReceiver : (String -> msg) -> Sub msg


type alias Model =
    { message : String
    , count : Int
    , key : Key
    , origin : String
    }


type Msg
    = OnUrlChanged Url
    | OnUrlRequested UrlRequest
    | OnButtonClick
    | GotHelloMsg (Result Http.Error String)
    | GotSessionToken String
    | KeyPressed


init : String -> Url -> Key -> ( Model, Cmd Msg )
init origin url key =
    ( Model "Hello" 0 key origin, Cmd.none )


view : Model -> Document Msg
view model =
    let
        body =
            [ div []
                [ h1 [ class "text-3xl", class "font-bold", class "underline" ] [ text "Elm playground" ]
                , button [ onClick OnButtonClick ] [ text "+" ]
                , div [] [ text <| String.fromInt model.count ]
                , button [ onClick OnButtonClick ] [ text "-" ]
                , p [] [ text model.message ]
                ]
            ]
    in
    { title = "Elm playground"
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
            ( model, Cmd.batch [ requestSesssionToken () ] )

        GotHelloMsg result ->
            case result of
                Ok helloMsg ->
                    ( { model | message = helloMsg }, Cmd.none )

                Err _ ->
                    ( { model | message = "Shit happens" }, Cmd.none )

        GotSessionToken token ->
            ( { model | message = token }, Cmd.none )

        KeyPressed ->
            ( { model | count = model.count + 1 }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ sessionTokenReceiver GotSessionToken
        , onKeyPress (Decode.succeed KeyPressed)
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
