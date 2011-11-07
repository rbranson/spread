# Spread is a simple way to run seed data based on the current Rails environment.
# Simply create a +seeds/+ directory under +db/+ and put your environment-specific
# seeds in there. Name each file the name of the environment followed by +.rb+.
# To load these seeds, simply add a call to +Spread.load+ to your +seeds.rb+ file.
# If you have a more complex environment, use the +seed+ method to tell Spread to
# load certain seed files for certain environments. HINT: This can also be used to
# break your seed files out and organize them.
#
# Using :all as an environment will cause Spread to apply the settings to all
# environments.

class Spread
  class << self
    # Tells Spread to load a seed file for a specific environment. Spread is smart enough
    # not to load a seed more than once. This method takes a hash parameter and uses the
    # keys as the seed file and the value(s) as the environment to load this seed file in.
    #
    #  Spread.seed :production => :testing
    #  Spread.seed :flinstones => [ :production, :development, :testing, :staging ]
    #  Spread.seed :scooby => :production, :velma => :staging
    #
    def seed(mapping)
      mapping.each do |key, val|
        @seeds ||= {}
        [ val ].flatten.each do |env|
          @seeds[env] ||= []
          @seeds[env] << key unless @seeds.include?(key)
        end
      end
    end
  
    # Tells Spread to load any seeds for the specified environment within other
    # environment(s). This is a good for scenarios in which you'd like to mimick your
    # production environment.
    #
    #  Spread.any :production => :staging
    #  Spread.any :production => [ :staging, :preproduction ]
    #
    def any(mapping)
      mapping.each do |key, val|
        @anys       ||= {}
        @anys[key]  ||= []
        @anys[key]  +=  [ val ].flatten
      end
    end

    # Performs the actual loading of seed files setup in Spread. Add this to your seeds.rb
    # file to invoke it.
    def load
      to_load = []
      current = Rails.env.to_sym
      envs    = [ current, :all ]
      envs    += @anys[current] if @anys and @anys.has_key?(current)
      
      # We don't use uniq to preserve ordering as much as possible
      envs.each do |e|
        to_load += to_load_for(e).reject { |s| to_load.include?(s) }
      end
      
      # Explicit mappings mean we definitely load it
      to_load.each do |seed_file|
        path = File.join("db", "seeds", "#{seed_file.to_s}.rb")
        puts "Spread: loading seeds from #{path}"
        full_path = File.join(Rails.root, path)
        eval File.read(full_path), binding, full_path
      end
      
      # We load the current environments file optionally (only if it exists)
      current_path  = File.join("db", "seeds", "#{current.to_s}.rb")
      full_cpath    = File.join(Rails.root, current_path)
      if File.exist?(full_cpath)
        puts "Spread: loading seeds from #{current_path}"
        eval File.read(full_cpath), binding, full_cpath
      end
    end
  
  private
    
    def to_load_for(env)
      ret = []
      
      if @seeds
        # We don't use uniq to preserve ordering as much as possible
        @seeds.each do |env, seeds|
          ret += seeds.reject { |s| ret.include?(s) }
        end
      end
      
      ret
    end
    
    def store_map_to(where, what)
      s = where.to_s
      eval("
        what.each do |key, val|
          #{s}       ||= {}
          #{s}[key]  ||= []
          #{s}[key]  +=  [ val ].flatten
        end
      ")
    end
  end
end
