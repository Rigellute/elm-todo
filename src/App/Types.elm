module App.Types exposing (..)

import Http


type alias Todo =
    { id : Int, text : String, isChecked : Bool }


type alias User =
    { id : Int
    , first_name : String
    , last_name : String
    , avatar : String
    }


type alias Model =
    { todoText : String, todos : List Todo, shouldShake : Bool, users : List User }


type Msg
    = OnToggleCheck Int
    | OnTypeTodo String
    | OnAddTodo Int
    | OnRemoveTodos
    | OnSelectAll
    | RemoveShake
    | OnRecieveUsers (Result Http.Error (List User))
