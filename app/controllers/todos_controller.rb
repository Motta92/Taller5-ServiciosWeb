class TodosController < ApplicationController
  def index
  	@todo_items = Todo.all # Query para coger todos los todos

    if params[:id] != nil
      @new_todo = Todo.find_by_id(params[:id])
    else
      @new_todo = Todo.new
    end
  end

  def create
    # Adiciona un toDo nuevo
  	todo = Todo.create(:todo_item => params[:todo][:todo_item], :deadline => params[:todo][:deadline]) #params[:name of the model][:name of the input field]
  	todo.save
  	if todo.valid?
  		flash[:success] = "Todo added successfully" 
  	else
  		flash[:error] = todo.errors.full_messages.join("<br>").html_safe
  	end
  	redirect_to index_path	
  end

  def complete
    # Cuando se presiona el boton toggle Todos para completar toDos

    if !params[:deletenson] and params[:todos_checkbox] != nil
      params[:todos_checkbox].each do |check|
      todo_id = check
      t = Todo.find_by_id(todo_id)
      #code to update the status here
      t.update_attribute(:completed, !t.completed)
      end
    else
      # Cuando se presiona el boton de delete para borrar multiples toDos

      #ids = params[:todos_checkbox].collect {|id| id.to_i}
      #Todo.where(:id => ids).destroy_all
      if params[:todos_checkbox] != nil
        params[:todos_checkbox].each do |check|
        todo_id = check
        t = Todo.find_by_id(todo_id)
        t.delete
        t.save
        end
        flash[:success]="Eliminados todos por sucios"
      end
    end
    redirect_to index_path #:action => 'index'
  end

  def delete
    # Elimina los toDos que esten marcados como terminados
    todo_id = params[:id]
    t = Todo.find_by_id(todo_id)
    t.delete
    t.save
    redirect_to index_path #:action => 'index'
  end


  def update
    todo = Todo.update(params[:id],:todo_item => params[:todo][:todo_item], :deadline => params[:todo][:deadline])
    todo.save
    if todo.valid?
      flash[:success] = "Todo updated successfully" 
    else
      flash[:error] = todo.errors.full_messages.join("<br>").html_safe
    end
    redirect_to index_path  
  end

end
