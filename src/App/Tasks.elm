module App.Tasks exposing (getUsers)

import App.Types exposing (Msg(OnRecieveUsers), User)
import Http
import Json.Decode as Json


getUsers : Cmd Msg
getUsers =
    let
        url =
            "https://reqres.in/api/users?page=1"

        request =
            Http.get url decodeUsers
    in
    Http.send OnRecieveUsers request


decodeUsers : Json.Decoder (List User)
decodeUsers =
    Json.at [ "data" ] (Json.list decodeUser)


decodeUser : Json.Decoder User
decodeUser =
    Json.map4 User
        (Json.field "id" Json.int)
        (Json.field "first_name" Json.string)
        (Json.field "last_name" Json.string)
        (Json.field "avatar" Json.string)
