initialState = [
  {
    text: 'Use Redux'
    completed: false
    id: 0
  }
]

todos = (state = initialState, action) ->
  switch action.type
    when 'ADD_TODO'
      id =
        if state.length > 0 then Math.max(state.map((todo) => todo.id)...) + 1
        else 0
      [
        {
          id: id
          completed: false
          text: action.text
        },
        state...
      ]

    when 'EDIT_TODO'
      state.map((todo) =>
        if todo.id == action.id
          Object.assign({}, todo, { text: action.text })
        else
          todo
      )

    when 'DELETE_TODO'
      state.filter((todo) =>
        todo.id != action.id
      )

    when 'COMPLETED_TODO'
      state.map((todo) =>
        if todo.id == action.id
          Object.assign({}, todo, { completed: !todo.completed })
        else
          todo
      )

    when 'COMPLETED_ALL'
      areAllMarked = state.every((todo) => todo.completed)
      state.map((todo) => Object.assign({}, todo, completed: !areAllMarked))

    when 'CLEAR_COMPLETED'
      state.filter((todo) => todo.completed == false)

    else return state

module.exports = todos
