module App.TodoComponent exposing (renderTodosFromList)

import App.Types exposing (Msg(OnToggleCheck))
import Html exposing (div, input, label, span, text)
import Html.Attributes exposing (checked, class, type_)
import Html.Events exposing (onClick)


listItem item =
    label [ class "todo-item" ]
        [ input
            [ type_ "checkbox"
            , class "checkbox"
            , onClick (OnToggleCheck item.id)
            , checked item.isChecked
            ]
            []
        , span [ class "label-inline", class "todo-text" ] [ text item.text ]
        ]


renderTodosFromList model =
    div []
        (List.map (\item -> listItem item) model.todos)
