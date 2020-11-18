dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/shared_examples/**/*.rb"].sort.each { |f| require f }

def platforms
  {
    'RedHat-7' => {
      python_version: 'system',
      virtualenv_provider: '/usr/bin/virtualenv',
      pip_provider: 'pip',
    },
    'RedHat-8' => {
      python_version: '2',
      virtualenv_provider: '/usr/bin/virtualenv-2',
      pip_provider: 'pip2',
    },
  }
end
