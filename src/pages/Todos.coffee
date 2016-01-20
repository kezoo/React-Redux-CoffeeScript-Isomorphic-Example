React = require('react')
{ bindActionCreators } = require('redux')
{ connect } = require('react-redux')
TodoActions = require('../actions/todosActions')
classnames = require('classnames')

class Todos extends React.Component
  propTypes =
    text: React.PropTypes.string
    editing: React.PropTypes.bool
    addTodo: React.PropTypes.func.isRequired
    todos: React.PropTypes.array.isRequired
    actions: React.PropTypes.object.isRequired

  constructor: (props, context) ->
    super(props, context)
    @state =
      text: @props.text || ''
      editing: false
      displayMode: 'all'

  handleSubmit: (e) =>
    @actions.addTodo(@state?.text) if e.which == 13

  handleInputChange: (e) =>
    if @state?.editing
      @setState({ editText: e.target.value.trim() })
    else
      @setState({ text: e.target.value.trim() })

  handleSave: (e) =>
    e.preventDefault()
    @actions.addTodo(@state?.text)
    @setState({text: ''})

  handleDbClick: (id, text) =>
    @setState({editId: id})
    @setState({editing: true})
    @setState({editText: text})

  handleInputBlur: (editable) =>
    if editable
      @setState({editing: false})
      @actions.editTodo(@state?.editId, @state?.editText)

  handleDelete: (id) =>
    @actions.deleteTodo(id)

  handleCheckboxChange: (id) =>
    @actions.completedTodo(id)

  handleCompleteAll: =>
    @actions.completedAll()

  handleClearCompleted: =>
    @actions.clearCompleted()

  handleDisplayAll: =>
    @setState({displayMode: 'all'})

  handleDisplayActived: =>
    @setState({displayMode: 'actived'})

  handleDisplayCompleted: =>
    @setState({displayMode: 'completed'})

  render: ->
    @actions = @props.actions
    @todos = @props.todos
    allMarked = @todos.every((todo) => todo.completed) and @todos[0]
    <div className="container">
      <div id="Todos">
        {
          todoInput =
            value: @state.text || ''
            editable: false
          @renderTodoInput(todoInput)
        }
        <button onClick={@handleSave} id="Todos-btn-submit" >
          Submit
        </button>
        <br />
        <input type="checkbox" checked={allMarked}
               onChange={@handleCompleteAll} />
        { @renderTodoList() }
        { @renderBottomControls() }
      </div>
    </div>

  renderTodoList: =>
    <ul>
      {
        todosArray = []
        switch @state?.displayMode
          when 'all'
            todosArray = @todos
          when 'actived'
            todosArray = @todos.filter((todo) => todo.completed == false)
          when 'completed'
            todosArray = @todos.filter((todo) => todo.completed == true)
        todosArray.map((todo) => @renderTodoItem(todo))
      }
    </ul>

  renderTodoItem: (todo) ->
    classes = classnames(
      'todo-input'
      'editing': @state.editing
    )
    todoItemClasses = classnames(
      'Todo-item'
      'Todo-completed': todo.completed
    )
    todoInput =
      value: todo.text
      classes: classes
      editable: true
    <li className={todoItemClasses}>
      <input type="checkbox"
             onChange={() => @handleCheckboxChange(todo.id)}
             checked={todo.completed} />
      {
        if @state?.editing and todo.id == @state?.editId
          todoInput.value = @state?.editText || todo.text
          @renderTodoInput(todoInput)
        else
          <label onDoubleClick={() => @handleDbClick(todo.id, todo.text)}>
            {todo.text}
          </label>
      }
      <button className="Todo-delete"
              onClick={() => @handleDelete(todo.id)}>
        X
      </button>
    </li>

  renderTodoInput: (todoInput) =>
    <input type="text"
           className={todoInput.classes || 'todo-input'}
           placeholder="New todo"
           value={todoInput.value||''}
           onKeyDown={@handleSubmit}
           onChange={@handleInputChange}
           autoFocus="true"
           onBlur={() => @handleInputBlur(todoInput.editable)}
    />

  renderBottomControls: =>
    itemLook =
      if @todos.length > 1 then 'items'
      else 'item'
    <div>
      <span>{@todos.length} {itemLook} left</span>
      <div>
        <button onClick={@handleDisplayAll}>All</button>
        <button onClick={@handleDisplayActived}>Active</button>
        <button onClick={@handleDisplayCompleted}>Completed</button>
        <button onClick={@handleClearCompleted}>
          Clear Completed
        </button>
      </div>
    </div>

module.exports = connect(
  (state) => (todos: state.todos)
  (dispatch) => (actions: bindActionCreators(TodoActions, dispatch))
)(Todos)
