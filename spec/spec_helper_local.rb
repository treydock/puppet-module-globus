# frozen_string_literal: true

dir = __dir__
Dir["#{dir}/shared_examples/**/*.rb"].sort.each { |f| require f }

def platforms
  {
    'RedHat-7' => {
      python_version: '3',
      pip_provider: 'pip3',
      venv_python_version: '3.6'
    },
    'RedHat-8' => {
      python_version: '3',
      pip_provider: 'pip3',
      venv_python_version: '3.6'
    },
    'Debian-9' => {
      python_version: '3',
      pip_provider: 'pip',
      venv_python_version: 'system'
    },
    'Debian-10' => {
      python_version: '3',
      pip_provider: 'pip',
      venv_python_version: 'system'
    },
    'Debian-18.04' => {
      python_version: '3',
      pip_provider: 'pip',
      venv_python_version: 'system'
    },
    'Debian-20.04' => {
      python_version: '3',
      pip_provider: 'pip',
      venv_python_version: 'system'
    }
  }
end

def support_v4(facts)
  return false if facts[:os]['release']['major'].to_i == 8 && facts[:os]['family'] == 'RedHat'

  true
end
