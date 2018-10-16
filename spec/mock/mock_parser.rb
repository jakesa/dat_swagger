

class MockParser

  class << self

    def models
      ['TestModel', 'OtherTestModel']
    end

    def routes(method:)
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

  end
end