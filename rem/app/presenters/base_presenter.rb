


class BasePresenter
  def initialize(object, template)
    @object, @template = object, template
  end

  private

  def self.presents(name)
    define_method(name) { @object }
  end

  def h
    @template
  end

  def markdown(text)
    # TODO
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end
end
