
class MockDefinition
  def data
    {
        testData1:{
            required: ['name'],
            properties: {
                name: '',
                address: '',
                phone: ''
            },
            description: 'This is a test'
        },
        otherTestData:{
            required: ['address'],
            properties: {
                name: '',
                address: '',
                phone: ''
            },
            description: 'This is also a test'
        }
    }
  end
end