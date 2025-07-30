# CacheService provides a simple interface for caching and retrieving Ruby objects
# using Rails caching with customizable TTL and key generation based on object fields
class CacheService
  DEFAULT_TTL = 30.minutes

  # Class-level fetch method that instantiates a new CacheService
  # and delegates to the instance method `#fetch`.
  #
  # @param args [Array] Positional arguments to pass to the instance method (`klass`, `field_name`, `field_value`)
  # @param kwargs [Hash] Keyword arguments (`ttl:`) to pass to the instance method
  # @yield Block that returns the object to cache if not already cached
  # @return [Array<Object, Time, Boolean>] The cached/fetched object, its cached timestamp, and whether it was found in cache
  def self.fetch(*args, **kwargs, &block)
    new.fetch(*args, **kwargs, &block)
  end

  # Fetches an object from cache or stores it if not present, returning the object and its cached timestamp
  #
  # @param klass [Class] The class of the object to cache/fetch (used as cache key prefix)
  # @param field_name [String, Symbol] The field name to use as the cache key
  # @param field_value [Object] The value of the field to use as the cache key
  # @param ttl [Integer, nil] Time to live in seconds (defaults to DEFAULT_TTL)
  # @yield Block that returns the object to cache if not already cached
  # @return [Array<Object, Time, Boolean>] The cached/fetched object, its cached timestamp, and whether it was found in cache
  def fetch(klass, field_name, field_value, ttl: DEFAULT_TTL, &block)
    cache_key = generate_cache_key(klass, field_name, field_value)
    cached_data = Rails.cache.read(cache_key)

    if cached_data
      [ cached_data[:object], cached_data[:cached_at], true ]
    else
      cached_at = Time.current
      object = block.call
      Rails.cache.write(cache_key, { object: object, cached_at: cached_at }, expires_in: ttl)
      [ object, cached_at, false ]
    end
  end

  private

  # Generates a cache key based on class name, field name, and field value
  #
  # @param klass [Class] The class used for the cache key prefix
  # @param field_name [String, Symbol] The field name used in the cache key
  # @param field_value [Object] The field value used in the cache key
  # @return [String] The generated cache key
  def generate_cache_key(klass, field_name, field_value)
    "#{klass.name.underscore}/#{field_name}/#{field_value}"
  end
end
