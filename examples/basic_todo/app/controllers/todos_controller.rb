class TodosController < ApplicationController
  include Aldous::Controller

  controller_actions :index, :new, :create, :edit, :update, :destroy
end
