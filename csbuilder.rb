class Collection
  INTERVALS = YAML.load_file('intervals.yml')
  NATS = %w(A B C D E F G)
  ENHARMS = YAML.load_file('enharmonics.yml')
  ACCIDENTALS = ['', '#', 'b']

  def initialize(root, quality, source)
    @root = root
    @quality = quality
    @source = source
  end
  
  def generate
    scale = []
    @source[my_collection][2].each do |int|
      scale.push(determine_tone(int))
    end
    scale.join(' ')
  end

  private

  def my_collection
    @source.find { |k, v| k == @quality}.first
  end
  
  def determine_tone(int)
    h_steps = INTERVALS[int][0]
    n_steps = INTERVALS[int][1]

    if eh_index + h_steps > 11
      fetch_tone(h_steps - 12, n_steps)
    else
      fetch_tone(h_steps, n_steps)
    end
  end

  def eh_index
    ENHARMS.index(ENHARMS.detect { |arr| arr.include?(@root) })
  end

  def fetch_tone(h_steps, n_steps)
    target = if NATS.index(@root[0, 1]) + n_steps > 6
               NATS.index(@root[0, 1]) + n_steps - 7
             else
               NATS.index(@root[0, 1]) + n_steps
             end

    ENHARMS.fetch(eh_index + h_steps).detect { |n| n.include?(NATS[target]) }
  end
end
