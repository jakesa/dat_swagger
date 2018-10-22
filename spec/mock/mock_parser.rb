

class MockParser

  class << self

    def models
      ['TestModel', 'OtherTestModel']
    end

    def routes(method: nil)
      {
          get:{
              route1: {
                  stuff: 'stuff'
              },

          },
          post:{
              route2: {
                  stuff: 'other stuff'
              }
          }
      }
    end

    def parse(path:)
      self
    end

  end
end