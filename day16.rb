require_relative './shared'

input = File.read('day16.input').chars
  .map { _1.to_i(16).to_s(2).rjust(4, '0') }
  .join

parse_packet = ->(start_ptr, version_mode) do
  ptr = start_ptr

  read = ->(bits) { input[ptr ... (ptr += bits)].to_i(2) }

  version = read.(3)
  type_id = read.(3)

  if type_id == 4
    number = ""
    (
      is_last_group = (read.(1) == 0)
      number << input[ptr ... (ptr += 4)]
    ) until is_last_group

    return [version_mode ? version : number.to_i(2), ptr]
  end

  subpacket_results = []

  length_mode = read.(1) == 0
  has_more_subpackets =
    if length_mode
      subpacket_length = read.(15)
      target_ptr = ptr + subpacket_length
      -> { ptr < target_ptr }
    else
      num_subpackets = read.(11)
      -> { subpacket_results.length < num_subpackets }
    end

  while has_more_subpackets.()
    subpacket_value, ptr = parse_packet.(ptr, version_mode)
    subpacket_results << subpacket_value
  end

  result =
    case type_id
    in _ if version_mode
      version + subpacket_results.sum
    in 0
      subpacket_results.reduce(:+)
    in 1
      subpacket_results.reduce(:*)
    in 2
      subpacket_results.min
    in 3
      subpacket_results.max
    in 5
      subpacket_results[0] > subpacket_results[1] ? 1 : 0
    in 6
      subpacket_results[0] < subpacket_results[1] ? 1 : 0
    in 7
      subpacket_results[0] == subpacket_results[1] ? 1 : 0
    end

  [result, ptr]
end

# Part 1

total_versions, = parse_packet.(0, true)

puts total_versions # 925

# Part 2

value, = parse_packet.(0, false)

puts value # 342997120375
