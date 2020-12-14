dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/shared_examples/**/*.rb"].sort.each { |f| require f }

def platforms
  {
    'RedHat-7' => {
      python_version: 'system',
      virtualenv_provider: 'virtualenv',
      pip_provider: 'pip',
    },
    'RedHat-8' => {
      python_version: '3',
      virtualenv_provider: 'virtualenv-3',
      pip_provider: 'pip3',
    },
    'Debian-9' => {
      python_version: 'system',
      virtualenv_provider: 'virtualenv',
      pip_provider: 'pip',
    },
    'Debian-10' => {
      python_version: 'system',
      virtualenv_provider: 'virtualenv',
      pip_provider: 'pip',
    },
    'Debian-18.04' => {
      python_version: 'system',
      virtualenv_provider: 'virtualenv',
      pip_provider: 'pip',
    },
    'Debian-20.04' => {
      python_version: 'system',
      virtualenv_provider: 'virtualenv',
      pip_provider: 'pip',
    },
  }
end

def support_v4(facts)
  return false if facts[:os]['release']['major'].to_i == 8 && facts[:os]['family'] == 'RedHat'
  true
end
