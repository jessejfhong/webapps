port module Main exposing (main)

import Browser exposing (Document)
import Html exposing (button, div, footer, h2, header, main_, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode as D exposing (Decoder)


port requestSessionToken : () -> Cmd msg


port sessionToken : (String -> msg) -> Sub msg


type alias Model =
    { title : String
    , origin : String
    , message : String
    }


type Msg
    = Loaded
    | GotSessionToken String
    | GotUser (Result Http.Error User)
    | ButtonClick String


type alias User =
    { name : String
    , age : Int
    }


userDecoder : Decoder User
userDecoder =
    D.map2 User
        (D.field "name" D.string)
        (D.field "age" D.int)


getUser origin token =
    Http.request
        { method = "GET"
        , headers = [ Http.header "authorization" ("Bearer " ++ token) ]
        , url = origin ++ "/data/user.json"
        , body = Http.emptyBody
        , expect = Http.expectJson GotUser userDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


init : String -> ( Model, Cmd Msg )
init origin =
    ( Model "Shopify" origin "Hey there!", Cmd.none )


view : Model -> Document Msg
view model =
    let
        headerView =
            header []
                [ h2 [ class "text-3xl", class "font-bold" ] [ text "Hello" ] ]

        mainView =
            main_ []
                [ p [] [ text model.message ]
                , button [ ButtonClick "args" |> onClick ] [ text "Click" ]
                ]

        footerView =
            footer []
                [ div [] [ text "footer secton, hello" ] ]
    in
    { title = model.title
    , body =
        [ headerView
        , mainView
        , footerView
        ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded ->
            ( model, Cmd.none )

        GotSessionToken token ->
            ( model, getUser model.origin token )

        GotUser result ->
            case result of
                Ok user ->
                    ( { model | message = user.name }, Cmd.none )

                Err err ->
                    ( { model | message = "Failed to get user" }, Cmd.none )

        ButtonClick _ ->
            ( model, requestSessionToken () )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ sessionToken GotSessionToken
        ]


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
