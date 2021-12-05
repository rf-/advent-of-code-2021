# Refinement for Array that adds geometric operations on [x, y] tuples,
# parameterized by Y facing up or down
PointOps = ->(system = :y_down) do
  Module.new do
    const_set :COORDINATE_SYSTEM, system
    const_set :ORIGIN, [0, 0]
    const_set :UP, [0, system == :y_down ? -1 : 1]
    const_set :DOWN, [0, system == :y_down ? 1 : -1]
    const_set :LEFT, [-1, 0]
    const_set :RIGHT, [1, 0]

    refine Array do
      def x
        self[0]
      end

      def y
        self[1]
      end

      def times(magnitude)
        map { _1 * magnitude }
      end

      def plus(vector)
        [x + vector.x, y + vector.y]
      end

      def rotate_left
        if COORDINATE_SYSTEM == :y_up
          [-y, x]
        else
          [y, -x]
        end
      end

      def rotate_right
        if COORDINATE_SYSTEM == :y_up
          [y, -x]
        else
          [-y, x]
        end
      end

      def angle(to_point)
        rads = Math.atan2(
          (to_point.y - y) * (COORDINATE_SYSTEM == :y_up ? 1 : -1),
          to_point.x - x
        )
        (rads / (2 * Math::PI)) * 360
      end

      def bearing(to_point)
        (450 - angle(to_point)) % 360
      end

      def distance(to_point = ORIGIN)
        Math.sqrt(((to_point.x - x)**2) + ((to_point.y - y)**2))
      end

      def taxicab_distance(to_point = ORIGIN)
        (to_point.x - x).abs + (to_point.y - y).abs
      end

      def line(to_point)
        unless bearing(to_point) % 45 == 0
          raise "Line must be orthogonal or diagonal"
        end

        x_step = x < to_point.x ? 1 : x > to_point.x ? -1 : 0
        y_step = y < to_point.y ? 1 : y > to_point.y ? -1 : 0

        line = [self]
        xx, yy = x, y
        until line[-1] == to_point
          xx += x_step
          yy += y_step
          line << [xx, yy]
        end

        line
      end
    end
  end
end
