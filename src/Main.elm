module Main exposing (..)

import App.State
import App.Tasks
import App.TodoComponent as TodoComponent
import App.Types exposing (Model, Msg(..))
import App.UserComponent as UserComponent
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (keyCode, on, onClick, onInput, targetValue)
import Json.Decode as Json


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


onAnimationEnd msg =
    Html.Events.on "animationend" (Json.succeed msg)



---- MODEL ----


init : ( Model, Cmd Msg )
init =
    ( { todoText = ""
      , todos = []
      , shouldShake = False
      , users = []
      }
    , App.Tasks.getUsers
    )



---- VIEW ----


view : Model -> Html Msg
view model =
    section [ class "container", class "container-padding" ]
        [ h1 [ class "centered-header" ] [ text "Todo list" ]
        , div
            [ classList
                [ ( "shake", model.shouldShake )
                , ( "animated", model.shouldShake )
                ]
            , onAnimationEnd RemoveShake
            ]
            [ input
                [ type_ "text"
                , onInput OnTypeTodo
                , value model.todoText
                , onKeyDown OnAddTodo
                , placeholder "Add your todo!"
                ]
                []
            ]
        , fieldset [] [ TodoComponent.renderTodosFromList model ]
        , div [ class "button-container" ]
            [ button
                [ class "button"
                , onClick OnRemoveTodos
                ]
                [ text "Remove completed tasks" ]
            , button
                [ class "button button-outline", onClick OnSelectAll ]
                [ text "Select all" ]
            ]
        , h4 [] [ text "Collaborators" ]
        , div []
            (List.map
                UserComponent.render
                model.users
            )
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = App.State.update
        , subscriptions = always Sub.none
        }
