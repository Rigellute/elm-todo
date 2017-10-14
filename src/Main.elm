module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (checked, class, classList, placeholder, src, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput, targetValue)
import Json.Decode as Json


listItem item =
    div []
        [ input [ type_ "checkbox", onClick (OnToggleCheck item.id), checked item.isChecked ] []
        , label [ classList [ ( "label-inline", True ), ( "todo-item", True ) ] ] [ text item.text ]
        ]


renderList model =
    div []
        (List.map (\item -> listItem item) model.todos)


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)



---- MODEL ----


type alias Todo =
    { id : Int, text : String, isChecked : Bool }


type alias Model =
    { todoText : String, todos : List Todo }


init : ( Model, Cmd Msg )
init =
    ( { todoText = "", todos = [] }, Cmd.none )



---- UPDATE ----


type Msg
    = OnToggleCheck Int
    | OnTypeTodo String
    | OnAddTodo Int
    | OnRemoveTodos
    | OnSelectAll


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnToggleCheck index ->
            ( { model | todos = List.map (updateIsChecked index) model.todos }, Cmd.none )

        OnTypeTodo newTodo ->
            ( { model | todoText = newTodo }, Cmd.none )

        OnAddTodo key ->
            ( if key == 13 || key == 0 then
                addTodo model
              else
                model
            , Cmd.none
            )

        OnRemoveTodos ->
            ( { model | todos = List.filter (\item -> item.isChecked == False) model.todos }, Cmd.none )

        OnSelectAll ->
            ( { model | todos = List.map (\item -> { item | isChecked = True }) model.todos }, Cmd.none )


updateIsChecked : Int -> Todo -> Todo
updateIsChecked index item =
    if item.id == index then
        { item | isChecked = not item.isChecked }
    else
        item


addTodo model =
    { model | todos = List.reverse (model.todos ++ [ { id = List.length model.todos, text = model.todoText, isChecked = False } ]), todoText = "" }



---- VIEW ----


view : Model -> Html Msg
view model =
    section [ classList [ ( "container", True ), ( "container-padding", True ) ] ]
        [ h1 [ class "centered-header" ] [ text "Todo list" ]
        , input [ type_ "text", onInput OnTypeTodo, value model.todoText, onKeyDown OnAddTodo, placeholder "Add your todo!" ] []
        , renderList model
        , div [] [ button [ class "button", onClick OnRemoveTodos ] [ text "Remove completed tasks" ] ]
        , div [] [ button [ class "button button-outline", onClick OnSelectAll ] [ text "Select all" ] ]
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
