editTodo = (id, text) -> { type: 'EDIT_TODO', id, text }

addTodo = (text) ->  { type: 'ADD_TODO', text }

deleteTodo = (id) -> { type: 'DELETE_TODO', id }

completedTodo = (id) -> { type: 'COMPLETED_TODO', id }

completedAll = (id) -> { type: 'COMPLETED_ALL' }

clearCompleted = (id) -> { type: 'CLEAR_COMPLETED' }

module.exports = { editTodo, addTodo, deleteTodo, completedTodo
  completedAll, clearCompleted }
