dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/shared_examples/**/*.rb"].sort.each { |f| require f }

def support_cli(facts)
  return false if facts[:os]['release']['major'].to_i <= 6
  true
end

def support_sdk(facts)
  support_cli(facts)
end

def support_v5(facts)
  return false if facts[:os]['release']['major'].to_i <= 6
  true
end
