module Main exposing (..)

import AnimationFrame exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (keyCode, on, onClick, onInput, targetValue)
import Json.Decode as Json
import Time exposing (Time, second)


listItem item =
    div []
        [ input
            [ type_ "checkbox"
            , onClick (OnToggleCheck item.id)
            , checked item.isChecked
            ]
            []
        , label
            [ classList
                [ ( "label-inline", True ), ( "todo-item", True ) ]
            ]
            [ text item.text ]
        ]


renderList model =
    div []
        (List.map (\item -> listItem item) model.todos)


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


onAnimationEnd msg =
    Html.Events.on "animationend" (Json.succeed msg)



---- MODEL ----


type alias Todo =
    { id : Int, text : String, isChecked : Bool }


type alias Model =
    { todoText : String, todos : List Todo, shouldShake : Bool }


init : ( Model, Cmd Msg )
init =
    ( { todoText = "", todos = [], shouldShake = False }, Cmd.none )



---- UPDATE ----


type Msg
    = OnToggleCheck Int
    | OnTypeTodo String
    | OnAddTodo Int
    | OnRemoveTodos
    | OnSelectAll
    | RemoveShake


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnToggleCheck index ->
            ( { model
                | todos =
                    List.map
                        (updateIsChecked index)
                        model.todos
              }
            , Cmd.none
            )

        OnTypeTodo newTodo ->
            ( { model | todoText = newTodo }, Cmd.none )

        OnAddTodo key ->
            ( if key == 13 && model.todoText == "" then
                { model | shouldShake = True }
              else if key == 13 then
                addTodo model
              else
                model
            , Cmd.none
            )

        OnRemoveTodos ->
            ( { model
                | todos =
                    List.filter
                        (\item -> item.isChecked == False)
                        model.todos
              }
            , Cmd.none
            )

        OnSelectAll ->
            ( { model
                | todos =
                    List.map
                        (\item -> { item | isChecked = True })
                        model.todos
              }
            , Cmd.none
            )

        RemoveShake ->
            ( { model | shouldShake = False }, Cmd.none )


updateIsChecked : Int -> Todo -> Todo
updateIsChecked index item =
    if item.id == index then
        { item | isChecked = not item.isChecked }
    else
        item


addTodo model =
    { model
        | todos =
            List.reverse
                (model.todos
                    ++ [ { id = List.length model.todos
                         , text = model.todoText
                         , isChecked = False
                         }
                       ]
                )
        , todoText = ""
    }



---- VIEW ----


view : Model -> Html Msg
view model =
    section [ classList [ ( "container", True ), ( "container-padding", True ) ] ]
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
        , renderList model
        , div []
            [ button
                [ class "button"
                , onClick OnRemoveTodos
                ]
                [ text "Remove completed tasks" ]
            ]
        , div []
            [ button
                [ class "button button-outline", onClick OnSelectAll ]
                [ text "Select all" ]
            ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
