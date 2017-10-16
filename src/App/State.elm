module App.State exposing (update)

import App.Types exposing (Model, Msg(..), Todo, User)


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

        OnRecieveUsers (Ok newUsers) ->
            ( { model | users = newUsers }, Cmd.none )

        OnRecieveUsers (Err _) ->
            ( model, Cmd.none )


updateIsChecked : Int -> Todo -> Todo
updateIsChecked index item =
    if item.id == index then
        { item | isChecked = not item.isChecked }
    else
        item


addTodo : Model -> Model
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
