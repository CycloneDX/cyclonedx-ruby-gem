# frozen_string_literal: true

Then('the generated Json BOM file {string} matches {string}') do |generated_file, expected_file|
  generated_file_contents = File.read(expand_path(generated_file))
  expected_file_contents = File.read(expand_path(expected_file))

  serial_number_matcher = /\"serialNumber\": \"urn:uuid:[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\"/
  normalized_serial_number = '"serialNumber": "urn:uuid:00000000-0000-0000-0000-000000000000"'
  normalized_generated_file_contents = generated_file_contents.gsub(serial_number_matcher, normalized_serial_number)
  normalized_expected_file_contents = expected_file_contents.gsub(serial_number_matcher, normalized_serial_number)

  expect(normalized_expected_file_contents).to eq(normalized_generated_file_contents)
end
