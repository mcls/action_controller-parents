require 'bundler'
Bundler.require

require 'benchmark'
require 'action_controller/parents'

class Model
  class << self
    def find(id)
    end
  end
end
class Group < Model; end
class Event < Model; end

finder = ActionController::Parents::Finder.new(Group, Event)

n = 100_000
params =  { stuff: { x: 1, y: 2 }, data: 'bla', event_id: 1 }
Benchmark.bm(20) do |x|
  x.report("parent_resource")   {
    n.times do
      finder.parent_resource(params)
    end
  }
end
