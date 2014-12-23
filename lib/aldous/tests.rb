# NOTE this should only be required by tests since it removes the full
# functionality of Aldous
require 'aldous/controller_service/perform_with_rescue'
require 'aldous/service/error_free'
require 'aldous/service/error_raising'

# remove the original Prepended module for tests as it defines a perform method
# which does a lot of stuff that the you would have to be aware of and
# instead we replace it with the version below which basically just proxies to
# the original implementation
Aldous::ControllerService::PerformWithRescue::ActualPrependedMethods = Aldous::ControllerService::PerformWithRescue::PrependedMethods
Aldous::ControllerService::PerformWithRescue.send(:remove_const, :PrependedMethods)
Aldous::ControllerService::PerformWithRescue::PrependedMethods = Module.new do
  def perform
    super
  end
end

Aldous::Service::ErrorFree::ActualPrependedMethods = Aldous::Service::ErrorFree::PrependedMethods
Aldous::Service::ErrorFree.send(:remove_const, :PrependedMethods)
Aldous::Service::ErrorFree::PrependedMethods = Module.new do
  def perform
    super
  end
end

Aldous::Service::ErrorRaising::ActualPrependedMethods = Aldous::Service::ErrorRaising::PrependedMethods
Aldous::Service::ErrorRaising.send(:remove_const, :PrependedMethods)
Aldous::Service::ErrorRaising::PrependedMethods = Module.new do
  def perform!
    super
  end

  def perform
    perform!
  end
end
