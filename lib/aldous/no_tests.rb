# NOTE this restores regular Aldous functionality after 'aldous/test' was
# required
require 'aldous/controller_service/perform_with_rescue'
require 'aldous/service/error_free'
require 'aldous/service/error_raising'

if defined?(Aldous::ControllerService::PerformWithRescue::ActualPrependedMethods)
  Aldous::ControllerService::PerformWithRescue.send(:remove_const, :PrependedMethods)
  Aldous::ControllerService::PerformWithRescue::PrependedMethods = Aldous::ControllerService::PerformWithRescue::ActualPrependedMethods
  Aldous::ControllerService::PerformWithRescue.send(:remove_const, :ActualPrependedMethods)
end

if defined?(Aldous::Service::ErrorFree::ActualPrependedMethods)
  Aldous::Service::ErrorFree.send(:remove_const, :PrependedMethods)
  Aldous::Service::ErrorFree::PrependedMethods = Aldous::Service::ErrorFree::ActualPrependedMethods
  Aldous::Service::ErrorFree.send(:remove_const, :ActualPrependedMethods)
end

if defined?(Aldous::Service::ErrorRaising::ActualPrependedMethods)
  Aldous::Service::ErrorRaising.send(:remove_const, :PrependedMethods)
  Aldous::Service::ErrorRaising::PrependedMethods = Aldous::Service::ErrorRaising::ActualPrependedMethods
  Aldous::Service::ErrorRaising.send(:remove_const, :ActualPrependedMethods)
end
