port module Main exposing (main)

import Browser exposing (Document)
import Html exposing (button, div, footer, h2, header, hr, main_, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)



{-
   seek to solve the problem of getting a session token from outside of elm
   before making a http request
-}


port requestSessionToken : Value -> Cmd msg


port sessionToken : (Value -> msg) -> Sub msg


type alias Model =
    { title : String
    , origin : String
    , message : String
    }


type Msg
    = Loaded
    | GotHttpRequestData Value
    | GotHealthCheck (Result Http.Error String)
    | GetUser String
    | GotUser (Result Http.Error User)
    | GetProducts
    | GotProducts (Result Http.Error (List Product))


type alias User =
    { name : String
    , age : Int
    }


type alias Product =
    { name : String
    , price : Float
    }


type RequestData d
    = RequestData ( d, String )


userDecoder : Decoder User
userDecoder =
    D.map2 User
        (D.field "name" D.string)
        (D.field "age" D.int)


productsDecoder : Decoder (List Product)
productsDecoder =
    D.map2 Product
        (D.field "name" D.string)
        (D.field "price" D.float)
        |> D.list


makeGetRequest : String -> Http.Expect Msg -> (String -> String -> Cmd Msg)
makeGetRequest url expect =
    \origin token ->
        Http.request
            { method = "GET"
            , headers = [ Http.header "authorization" ("Bearer " ++ token) ]
            , url = origin ++ url
            , body = Http.emptyBody
            , expect = expect
            , timeout = Nothing
            , tracker = Nothing
            }


type HttpRequest
    = HttpRequest (String -> String -> Cmd Msg)


getUser origin token =
    makeGetRequest "/api/user/2" (Http.expectJson GotUser userDecoder) origin token


getProducts origin token =
    makeGetRequest "/data/products.json" (Http.expectJson GotProducts productsDecoder) origin token


healthCheck origin =
    Http.get
        { url = origin ++ "/api/hey"
        , expect = Http.expectString GotHealthCheck
        }


init : String -> ( Model, Cmd Msg )
init origin =
    ( Model "Shopify" origin "Hey there!~", healthCheck origin )


view : Model -> Document Msg
view model =
    let
        -- header
        viewHeader =
            header []
                [ h2 [ class "text-3xl", class "font-bold" ] [ text "Hello" ] ]

        -- body
        viewBody =
            main_ []
                [ p [] [ text model.message ]
                , button [ GetUser "args" |> onClick ] [ text "GetUser" ]
                , hr [] []
                , button [ GetProducts |> onClick ] [ text "GetProducts" ]
                ]

        -- footer
        viewFooter =
            footer []
                [ div [] [ text "footer secton, hello" ] ]
    in
    { title = model.title
    , body =
        [ viewHeader
        , viewBody
        , viewFooter
        ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded ->
            ( model, Cmd.none )

        GotHttpRequestData value ->
            -- when I finally get the token
            -- how can I tell which one to call
            -- getUser or getProducts
            let
                result =
                    D.decodeValue (D.field "token" D.string) value
            in
            case result of
                Ok token ->
                    ( model, getUser model.origin token )

                Err _ ->
                    ( model, Cmd.none )

        GotHealthCheck result ->
            case result of
                Ok str ->
                    ( { model | message = str }, Cmd.none )

                Err _ ->
                    ( { model | message = "GG" }, Cmd.none )

        GetUser userId ->
            -- encode whatever data need to make http request and pass it outside elm
            let
                obj =
                    E.object
                        [ ( "id", E.int 1 )
                        , ( "url", E.string ("/data/user.json?id=" ++ userId) )
                        , ( "type", E.string "user" ) -- used to determine what to expect
                        ]
            in
            ( model, requestSessionToken obj )

        GotUser result ->
            case result of
                Ok user ->
                    ( { model | message = user.name }, Cmd.none )

                Err err ->
                    ( { model | message = "Failed to get user" }, Cmd.none )

        GetProducts ->
            -- encode whatever data need to make http request and pass it outside elm
            let
                obj =
                    E.object
                        [ ( "id", E.int 2 )
                        , ( "url", E.string "/data/products.json" )
                        , ( "type", E.string "products" ) -- used to determine what to expect
                        ]
            in
            ( model, requestSessionToken obj )

        GotProducts result ->
            case result of
                Ok products ->
                    ( { model | message = "products" }, Cmd.none )

                Err _ ->
                    ( { model | message = "Failed to get products" }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ sessionToken GotHttpRequestData
        ]


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
