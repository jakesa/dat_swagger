
class MockModel

  class << self

    def random_method(number: )
      @number = number
    end

    def number
      @number
    end

    def some_other_method(params: )

    end

  end

end

class MockModel2
  class << self

    def model

    end

  end

end