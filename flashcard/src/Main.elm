module Main exposing (main)

import Browser exposing (Document)
import Html exposing (div, footer, h2, header, main_, p, text)
import Html.Attributes exposing (class)


type alias Model =
    { title : String
    , origin : String
    }


type Msg
    = Loaded


init : String -> ( Model, Cmd Msg )
init origin =
    ( Model "Flashcard" origin, Cmd.none )


view : Model -> Document Msg
view model =
    let
        headerView =
            header []
                [ h2 [ class "text-3xl", class "font-bold" ] [ text "Hello" ] ]

        mainView =
            main_ []
                [ p [] [ text "main section" ] ]

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


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
