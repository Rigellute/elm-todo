module App.UserComponent exposing (..)

import App.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


render : User -> Html.Html a
render user =
    div
        []
        [ div
            [ class "user-container" ]
            [ img
                [ src user.avatar
                , class "avatar"
                ]
                []
            , div
                [ class "column" ]
                [ div [ class "user-name" ] [ text (user.first_name ++ " " ++ user.last_name) ]
                ]
            ]
        ]
