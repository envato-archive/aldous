# Aldous

The basic idea behind this gem is that [Rails](https://github.com/rails/rails) is missing a few key things that make our lives especially painful when our applications start getting bigger and more complex. With Aldous we attempt to address some of these shortcomings, namely:

1) Bloated models that trample all over the single responsibility principle. God models that tend to appear despite our best intentions. Not to mention the complexity of testing objects that are so big and unwieldy.

Aldous attempts to address this, by introducing a light convention for creating service objects that conform to the same interface. See below, for the features that Aldous service objects have and how to use them in your app.

2) Big and bloated controllers (despite our best intentions) that contain business logic and are hard to test. Not to mention the logic that is spread among the various `before_actions` requiring mental compilation to understand a controller action fully. Lastly the instance variables spread all over the controller that get inherited by the view templates as global variables.

Aldous addresses this by introducing the concept of a controller action object. The Rails controllers still exist, but they contain no logic in them. All the logic moves to the action classes with one action per class. Instance variables from these don't automatically get inherited by the view templates and the job of `before_actions` is taken over by precondition objects. See below for a more detailed overview of Aldous controller actions.

3) Views that are not really views, but are instead view templates that inherit instance variables from controllers as globals and leave no good place for view-specific logic making us resort to hacky solutions like view helpers.

Aldous addresses this by introducing a concept of view objects which are actual ruby objects, these live alongside the standard Rails views (which we try to call templates from now on). These view objects provide a good place for view specific logic, which lets us remove much of the logic that Rails templates tend to accumulate. And being Ruby objects this logic can be tested like it should. See below for more details about Aldous view objects.

The key concepts that motivate Aldous are:

- a greater number of light and small objects which are easy to understand and test
- looser coupling between all parts of a larger application

No matter how big our applications get we want to maintain the rapid speed of feature development we usually only have at the start of a project. The two ideas above greatly facilitate this. As a side-effect we also achieve looser coupling with the web framework and more clearly defined business logic.

## Installation

Add this line to your application's Gemfile:

    gem 'aldous'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aldous

## Blog Posts About Aldous

It is difficult to explain all the motivations and thoughts and philosophy that have gone into this gem without bloating the Readme tremendously. So this Readme will remain focused on usage. Any extra stuff, such as how it all hangs together and why things are done a certain way will be delegated to blog posts which will be linked from here.

## Usage

All the concepts in Aldous are designed to work well when used together, but we also don't want to be too prescriptive, so you can easily use just some of the concepts without using others. You can take advantage of the service objects without worrying about controller action or view objects or if you prefer to just use the controller action you can do that too. Here is an in-depth explanation for how to hook everything up one concept at a time (with recommendations for how to achieve the best results).

### Service Objects

The first thing to do is to configure a folder for the services to live in, `app/services` is a good candidate. So go into your `app/config/application.rb` and add the following:

```ruby
config.autoload_paths += %W(
  #{config.root}/app/services
)

config.eager_load_paths += %W(
  #{config.root}/app/services
)
```

The next thing to think about is how you will name your service objects. I prefer a `*_service` convention (`create_user_service.rb`), that way you can always tell you're looking at a service object regardless of where it is being used. Also remember it's a service object, so name it like you would a method instead of like you would a class (e.g. it's not `UserCreatorService`, it's `CreateUserService`).

A typical Aldous service object might look something like this:

```ruby
class CreateUserService < Aldous::Service
  attr_reader :user_data_hash

  def initialize(user_data_hash)
    @user_data_hash = user_data_hash
  end

  def raisable_error
    MyApplication::Errors::UserError
  end

  def default_result_data
    {user: nil}
  end

  def perform
    user = User.new(user_data_hash)
    user.roles << Role.where(name: "account_holder").first

    if user.save
      Result::Success.new(user: user)
    else
      Result::Failure.new
    end
  end
end
```

A couple of things of note:

- it inherits from `Aldous::Service`, this is important as it gives it some nice behaviour.
- the `raisable_error`, `default_result_data` and `perform` methods are part of the public interface that is inherited from `Aldous::Service`

The only method you strictly *have* to override is `perform`, but I recommend you do all 3 for extra goodness that is explained below.

Here is how you would call it:

```ruby
hash = {}
result = CreateUserService.perform(hash)
if result.success?
  # do success stuff
else #result.failure?
  # do failure stuff
end
```

or

```ruby
hash = {}
begin
  result = CreateUserService.perform!(hash)
  if result.success?
    # do success stuff
  else #result.failure?
    # do failure stuff
  end
rescue MyApplication::Errors::UserError => e
end
```

or

```ruby
hash = {}
service = CreateUserService.build(hash)
result = service.perform
if result.success?
  # do success stuff
else #result.failure?
  # do failure stuff
end
```

As you can see, you don't use the constructor to build these objects, use `build` or call `perform` directly (otherwise you'll be missing all the nice features).

An Aldous service object can be either error free or error raising, here is what that means. If you construct the service object correctly via the factory method and/or call `perform`. The method call is guaranteed to never raise an error. When implementing the `perform` method you have to remember to return `Result::Success` for any success cases and return `Result::Failure` for any failure cases. If the code you have writted raises an error, it will be automatically caught and a `Result::Failure` will be returned. The idea is that a service either succeeds or fails and if an error occurs that's just a kind of failure.

However there are situations where you *want* the service to raise an error, for example if you're using it in a background job and an error means that the job will be retried (e.g. like `sidekiq` would do). For this purpose Aldous service objects automatically gain a `perform!` method. This will use the funtionality of your `perform` method, but if an error occurs it will be caught and then re-raised as the error type you specify in the `raisable_error` method. This way you always know that your services can return `Result::Success`, `Result::Failure` or raise the error type you specify depending on how you call them.

Service objects are immutable once they are constructed their state doens't change, but we may still want to return data to the user of the service. This is why `Result::Success` and `Result::Failure` are not just are not just semantic types they are also DTO (data transfer) objects. When you construct a `Result::Success` for example, it will automatically have reader methods defined on it with the names of the keys in `default_result_data` hash. An example to demonstrate:

```ruby
class CreateUserService < Aldous::Service
  def default_result_data
    {user: nil}
  end

  def perform
    Result::Success.new
  end
end

result = CreateUserService.perform
result.user  # will be equal to nil
```

or

```ruby
class CreateUserService < Aldous::Service
  def default_result_data
    {user: nil}
  end

  def perform
    Result::Success.new(user: user)
  end

  private

  def user
    User.new
  end
end

result = CreateUserService.perform
result.user  # will be a User instance
```

Hopefully you can see how this hangs together, the `default_result_data` method defines a hash of data with default values. This data will magically end up on the `Result::Success` and `Result::Failure` objects you construct in your perform method. If you pass a hash of data when you construct those object, that data will override the default values defined in the `default_result_data` method.

### Controller Actions

The first thing to do is to configure a folder for the controller actions to live in, `app/controller_actions` is a good candidate. So go into your `app/config/application.rb` and add the following:

```ruby
config.autoload_paths += %W(
  #{config.root}/app/controller_actions
)

config.eager_load_paths += %W(
  #{config.root}/app/controller_actions
)
```

Let's say we're creating a controller called `TodosController`, here is what it would look like now:

```ruby
class TodosController < ApplicationController
  include Aldous::Controller

  controller_actions :index, :new, :create, :edit, :update, :destroy
end
```

After you've done this, the code for the `index` action should live in, `app/controller_actions/todos_controller/index.rb` - pretty intuitive.

A controller action might look like this:

```ruby
class TodosController::Index < BaseAction
  def default_view_data
    super.merge({todos: todos})
  end

  def perform
    return view_builder.build(Home::ShowRedirect) unless current_user

    view_builder.build(Todos::IndexView)
  end

  private

  def todos
    Todo.where(user_id: current_user.id)
  end
end
```

The action above is also using Aldous view objects.

As you can see, the controller action lives under the namespace of the controller. I also recommend creating a `BaseAction` and inheriting from that for most of your actions. The `BaseAction` might look like this:

```ruby
class BaseAction < ::Aldous::ControllerAction
  def default_view_data
    {
      current_user: current_user,
      current_ability: current_ability,
    }
  end

  def preconditions
    [Shared::EnsureUserNotDisabledPrecondition]
  end

  def default_error_handler(error)
    Defaults::ServerErrorView
  end

  def current_user
    @current_user ||= FindCurrentUserService.perform(session).user
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
```

As you can see if inherits from `Aldous::ControllerAction`. The methods you should override are:

- `default_view_data` - this hash of data will be available to all the aldous view objects
- `preconditions` - this is used as a replacement for `before_actions`
- `default_error_handler` - this view will be rendered if an unhandled error gets raised in the action code

Similar to services, for actions you implement the `perform` method (might as well keep things consistent). All action classes have the same constructor signature, they take a controller object and you have access to this controller object in your action classes. Also a few methods from the controller get exposed directly to your action (params, session, cookies, request, response) for convenience. You can expose others via configuration in an initializer, or you can grab them from the controller instance you have access to.

Controller action are automatically error free, so any error that gets raised in the perform method, automatically get caught and a view you specify in `default_error_handler` will get rendered to handle that error.

Lets look at a slightly bigger controller action:

```ruby
class TodosController::Update < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def preconditions
    super.reject{|klass| klass == Shared::EnsureUserNotDisabledPrecondition}
  end

  def perform
    return view_builder.build(Home::ShowRedirect) unless current_user
    return view_builder.build(Defaults::BadRequestView, errors: [todo_params.error_message]) unless todo_params.fetch
    return view_builder.build(Todos::NotFoundView, todo_id: params[:id]) unless todo
    return view_builder.build(Defaults::ForbiddenView) unless current_ability.can?(:update, todo)

    if todo.update_attributes(todo_params.fetch)
      view_builder.build(Todos::IndexRedirect)
    else
      view_builder.build(Todos::EditView)
    end
  end

  private

  def todo
    @todo ||= Todo.where(id: params[:id]).first
  end

  def todo_params
    TodosController::TodoParams.build(params)
  end
end
```

Let's start with the `perform` method. As you can see it's fattish, but no fatter than regular controller methods if you take into account all the `before_actions`. The idea is to handle the special cases first and then perform the logic which will either succeed or fail. In our case we want to redirect to home if there is no `current_user`. The actual `current_user` method, comes from our `BaseAction`. If we can't fetch strong params we render a bad request view. If we couldn't find a `todo` we render a not found view. And if the current user isn't allowed to update the todo, we render a forbidden view. All of those are things we should think about and handle before we try to perform the logic of our update action. And all those things should be close to the logic of the action, so we can grok the full scope of the action easily without mental compilation. We then perform the logic and render or redirect based on the success or failure of that logic. As you might imagine, if the logic was more complex you would push it into a service object e.g.:

```ruby
class SignUpsController::Create < BaseAction
  def perform
    return view_builder.build(Todos::IndexRedirect) if current_user
    return view_builder.build(Defaults::BadRequestView, errors: [user_params.error_message]) unless user_params.fetch

    if create_user_result.success?
      SignInService.perform!(session, create_user_result.user)
      view_builder.build(Todos::IndexRedirect)
    else
      view_builder.build(SignUps::NewView)
    end
  end

  private

  def create_user_result
    @create_user_result ||= CreateUserService.perform(user_params.fetch)
  end

  def user_params
    @user_params ||= ::SignUpsController::UserParams.build(params)
  end
end
```

Let's talk about `default_view_data`. We first define this method in our `BaseAction` we them augment it in our actual actions. Eventually that whole hash of data will get bundles up into a DTO object and be available in whichever view object we end up rendering. You always know which data your view object will have access to and you directly control it with pure ruby and very limited magic.

Let's talk about the `preconditions` method. We usually want to define it in our `BaseAction` and only override it in our actual actions if we want to get rid of a particular precondition, which should happen infrequently. This method defines an array of classes, this classes will get instantiated and executed in the order they are defined before the actual action is executed. In most respects a precondition class looks and behaves exactly like an action class. The precondition also has access to the action instance:

```ruby
class Shared::EnsureUserNotDisabledPrecondition < BasePrecondition
  delegate :current_user, :current_ability, to: :action

  def perform
    if current_user && current_user.disabled && !current_ability.can?(:manage, :all)
      return view_builder.build(Defaults::ForbiddenView, errors: ['Your account has been disabled'])
    end
  end
end
```

I recommend having a base class for preconditions:

```ruby
class BasePrecondition < ::Aldous::Controller::Action::Precondition
end
```

Preconditions should be applicable to all or most actions, and if you need to switch a precondition off for a particular action, you can do so using ruby collection methods (e.g. `reject`).

Aldous provides a small helper for bundling strong params logic into an object:

```ruby
class SignUpsController::UserParams < Aldous::Params
  def permitted_params
    params.require(:user).permit(:email, :password)
  end

  def error_message
    'Missing param :user'
  end
end

::SignUpsController::UserParams.build(params)
```

When you have an instance of an `Aldous::Params` object, you just call `fetch` on it and it will either return the params hash you were after, or nil if something went wrong. You can put params object along side your actions, or if they are applicable across controllers, put it into `app/controller_actions/shared` just like you would with precondition objects.

### View Objects

The first thing to do is to configure a folder for the view objects to live in, we already have `app/views` for our view templates, so lets just put our view objects right there next to the templates. So go into your `app/config/application.rb` and add the following:

```ruby
config.autoload_paths += %W(
  #{config.root}/app/views
)

config.eager_load_paths += %W(
  #{config.root}/app/views
)
```

We have to understand that when we're talking about view objects, we're not necessarily talking about views as Rails would understand them. We're talking about any kind of output you would normally produce from a Rails controller (e.g. render view, redirect to location, send data, head etc.). In Aldous this concept is called - respondables and we have a different type of object to represent each one of these. There are `Renderable` object for standard view, `Redirectable` objects for redirects etc. The key thing is that a controller action always produces a respondable object and it's the responsibility of that object to do the right thing to produce the output that we expect. Example time, here is what a redirect object might look like:

```ruby
class Home::ShowRedirect < Aldous::Respondable::Redirectable
  def location
    view_context.root_path
  end
end
```

As you can see it inherits from `Aldous::Respondable::Redirectable` and all you have to do is to provide the location method. Here is what a renderable object (for views) might look like:

```ruby
class Home::ShowView < BaseView
  def template_data
    {
      template: 'home/show',
      locals: {}
    }
  end
end
```

with `BaseView` being:

```ruby
class BaseView < ::Aldous::Respondable::Renderable
  def default_template_locals
    {
      current_user: current_user,
      header_view: header_view,
    }
  end

  def current_user
    view_data.current_user
  end

  private

  def header_view
    view_builder.build(Modules::HeaderView)
  end
end
```

As you can see a view object ultimately inherits from `Aldous::Respondable::Renderable` and the key method to override is `template_data`. This method needs to return a hash with template or partial that we want to render as well as the locals that we want to supply. If we have a `BaseView` which I recommend, then we can also override the `default_template_locals` method. When you do this, some Aldous magic will happen and all the things in that hash will be available in all the templates as locals which is very handy for data that's common across all or most templates. The key things here is that you control it.

You construct view objects either in your controller actions or in other view objects, to do this you use the `view_builder` object `build` method. This object is always available and you don't need to worry about providing it, but if you ever want to override it (e.g. in tests), you can inject it also. The only place where you may have to construct view objects directly is in tests. The constructor signature of a view object is:

```ruby
def initialize(status, view_data, view_context, view_builder)
  @status = status
  @view_data = view_data
  @view_context = view_context
  @view_builder = view_builder
 end
```

The first variable is self explanatory, use it if you want to override the status for a particular view object. The second parameter is a DTO which contains all the data that comes from the `default_view_data` in your controller action. The last parameter is the `view_context` that you normally get from the controller. This is the context in which the view templates get executed in vanilla Rails.

You should only override the `default_template_locals` in a `BaseView` object. In the actual view object just provide the locals directly in the `template_data` method. Everything will get merged correctly by Aldous. You can also provide a default status for any view by overriding the `default_status` method.

Lets look at a more complex view object and the correspoding templates:

```ruby
class Todos::IndexView < BaseView
  def template_data
    {
      template: 'todos/index',
      locals: {
        todo_views: todo_views,
      }
    }
  end

  private

  def todos
    view_data.todos
  end

  def todo_views
    todos.map do |todo|
      todo_view(todo)
    end
  end

  def todo_view(todo)
    view_builder.build(Todos::IndexView::TodoView, todo: todo)
  end
end
```

our `BaseView` is:

```ruby
class BaseView < ::Aldous::Respondable::Renderable
  def default_template_locals
    {
      current_user: current_user,
      header_view: header_view,
    }
  end

  def current_user
    view_data.current_user
  end

  private

  def header_view
    view_builder.build(Modules::HeaderView)
  end
end
```

so our template `index.html.slim` has access to `current_user`, `header_view`, and `todo_views` as locals. Let's have a look at the template:

```ruby
- provide :title, "View Todos"

= render header_view.template

h1 Your Todos

= link_to 'Create New Todo', new_todo_path
= button_to 'Delete Completed Todos', all_completed_todos_path, method: :delete

- todo_views.each do |todo_view|
  = render todo_view.template
```

You can see how we render partials inside a template:

```ruby
= render header_view.template
```

If we needed to pass in extra locals for the partial (e.g. a form object), we could do:

```ruby
= render header_view.template(f: f)
```

In our case `header_view` will be available to all templates, which includes the layout, so we can pull it out of this template and add it to the layout instead.

The idea here is for templates to have very little logic besides boilerplate stuff like the `- todo_views.each` above. There should also be very few (or none at all) demeter violations in the template, as this stuff can be pushed up into the view objects now and handled more robustly, tested etc.

### Configuring Aldous

You can create an initializer for Aldous it would look like this:

```ruby
Aldous.configuration do |aldous|
  aldous.logger = Rails.logger
  aldous.error_reporter = MyApplication::ErrorReporter
  aldous.controller_methods_exposed_to_action += [:current_user]
end
```

The most interesting config option initially is the ability to supply the logger so that you can see relevant things in your log files and also pick up on any issues with Aldous itself. The `error_reporter` is an object that responds to `report`:

```ruby
module Aldous
  class DummyErrorReporter
    class << self
      def report(e, data = {})
        nil
      end
    end
  end
end
```

This can be used for things like sending errors to an error collection service or whatever else you want to do when exceptions occur.

You can also expose more methods from the Rails controller to the controller action by using `controller_methods_exposed_to_action`.

## Why is it called Aldous?

When we initially started using some of the things that would later become Aldous, we called it Brave New World (BNW). So when a lot of that functionality migrated into a gem we called it [Aldous](http://en.wikipedia.org/wiki/Aldous_Huxley) cause [Brave New World](http://en.wikipedia.org/wiki/Brave_New_World).

## Examples

There is a basic [example Rails app](examples/basic_todo) that lives in this repo. Run it up, and have a look at the code. Also one of the goals of Aldous was to make its own source code easy to understand read and modify for other people, to facilitate understading and cooperation. So, feel free to read the code itself to figure out how things hang together, start with the Aldous objects that you would inherit from e.g. `Aldous::ControllerAction`, `Aldous::Service`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
