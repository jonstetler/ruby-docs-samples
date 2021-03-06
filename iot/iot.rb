# Copyright 2018 Google, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Note: Code samples in this file set constants which cannot be set inside
#       method definitions in Ruby. To allow for this, code snippets in this
#       sample are wrapped in global lambdas.

$create_registry = -> (project_id:, location_id:, registry_id:, pubsub_topic:) do
  # [START iot_create_registry]
  # project_id   = "Your Google Cloud project ID"
  # location_id  = "The Cloud region that you created the registry in"
  # registry_id  = "The Google Cloud IoT Core device registry identifier"
  # pubsub_topic = "The Google Cloud PubSub topic to use for this registry"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The project / location where the registry is created.
  parent = "projects/#{project_id}/locations/#{location_id}"

  registry = Cloudiot::DeviceRegistry.new
  registry.id = registry_id
  registry.event_notification_configs = [Cloudiot::EventNotificationConfig::new]
  registry.event_notification_configs[0].pubsub_topic_name = pubsub_topic

  registry = iot_client.create_project_location_registry(
      parent, registry
  )

  puts "Created registry: #{registry.name}"
  # [END iot_create_registry]
end

$delete_registry = -> (project_id:, location_id:, registry_id:) do
  # [START iot_delete_registry]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region that you created the registry in"
  # registry_id = "The Google Cloud IoT Core device registry identifier"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  resource = "projects/#{project_id}/locations/#{location_id}/registries/#{registry_id}"

  result = iot_client.delete_project_location_registry(resource)
  puts "Deleted registry: #{registry_id}"
  # [END iot_delete_registry]
end

$get_iam_policy = -> (project_id:, location_id:, registry_id:) do
  # [START iot_get_iam_policy]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to get an IAM policy for"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent   = "projects/#{project_id}/locations/#{location_id}"
  resource = "#{parent}/registries/#{registry_id}"

  # List the devices in the provided region
  policy = iot_client.get_registry_iam_policy(
    resource
  )

  if policy.bindings
    policy.bindings.each do |binding|
      puts "Role: #{binding.role} Member: #{binding.members[0]}"
    end
  else
    puts "No bindings"
  end
  # [END iot_get_iam_policy]
end

$get_registry = -> (project_id:, location_id:, registry_id:) do
  # [START iot_get_registry]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region that you created the registry in"
  # registry_id = "The Google Cloud IoT Core device registry identifier"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  resource = "projects/#{project_id}/locations/#{location_id}/registries/#{registry_id}"

  # List the devices in the provided region
  registry = iot_client.get_project_location_registry(
    resource
  )

  puts "#{registry.id}:"
  puts "\tHTTP Config: #{registry.http_config.http_enabled_state}"
  puts "\tMQTT Config: #{registry.mqtt_config.mqtt_enabled_state}"
  puts "\tName: #{registry.name}"
  if registry.event_notification_configs
    registry.event_notification_configs.each do |config|
      puts "\tTopic: #{config.pubsub_topic_name}"
    end
  else
      puts "\tTopic: no associated topics"
  end
  # [END iot_get_registry]
end

$list_registries = -> (project_id:, location_id:) do
  # [START iot_list_registries]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region to list registries in"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  resource = "projects/#{project_id}/locations/#{location_id}"

  # List the devices in the provided region
  registries = iot_client.list_project_location_registries(
    resource
  )

  puts "Registries:"
  if registries.device_registries && registries.device_registries.any?
    registries.device_registries.each { |registry| puts "\t#{registry.id}" }
  else
    puts "\tNo device registries found in this region for your project."
  end
  # [END iot_list_registries]
end

$set_iam_policy = -> (project_id:, location_id:, registry_id:, member:, role:) do
  # [START iot_set_iam_policy]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to set an IAM policy for"
  # member      = "The member to add to the policy bindings"
  # role        = "The role for the binding the policy is set to"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent   = "projects/#{project_id}/locations/#{location_id}"
  resource = "#{parent}/registries/#{registry_id}"

  request = Google::Apis::CloudiotV1::SetIamPolicyRequest.new
  policy  = Google::Apis::CloudiotV1::Policy.new
  binding = Google::Apis::CloudiotV1::Binding.new
  binding.members = [member]
  binding.role    = role
  policy.bindings = [binding]
  request.policy  = policy

  # List the devices in the provided region
  res = iot_client.set_registry_iam_policy(
    resource, request
  )

  if res.bindings
    puts "Binding set:"
    res.bindings.each do |binding|
      puts "\tRole: #{binding.role} Member: #{binding.members[0]}"
    end
  else
    puts "No bindings"
  end
  # [END iot_set_iam_policy]
end

$create_es_device = -> (project_id:, location_id:, registry_id:, device_id:, cert_path:) do
  # [START iot_create_es_device]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to create a device in"
  # device_id   = "The identifier of the device to create"
  # cert_path   = "The path to the EC certificate"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent = "projects/#{project_id}/locations/#{location_id}/registries/#{registry_id}"

  device = Cloudiot::Device.new
  device.id = device_id

  pubkey = Google::Apis::CloudiotV1::PublicKeyCredential.new
  pubkey.key = File.read(cert_path)
  pubkey.format = "ES256_PEM"

  cred = Google::Apis::CloudiotV1::DeviceCredential.new
  cred.public_key = pubkey

  device.credentials = [cred]

  # Create the device
  device = iot_client.create_project_location_registry_device parent, device

  puts "Device: #{device.id}"
  puts "\tBlocked: #{device.blocked}"
  puts "\tLast Event Time: #{device.last_event_time}"
  puts "\tLast State Time: #{device.last_state_time}"
  puts "\tName: #{device.name}"
  # [END iot_create_es_device]
end

$create_rsa_device = -> (project_id:, location_id:, registry_id:, device_id:, cert_path:) do
  # [START iot_create_rsa_device]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to create a device in"
  # device_id   = "The identifier of the device to create"
  # cert_path   = "The path to the RSA certificate"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent = "projects/#{project_id}/locations/#{location_id}/registries/#{registry_id}"

  credential = Google::Apis::CloudiotV1::DeviceCredential.new
  credential.public_key = Google::Apis::CloudiotV1::PublicKeyCredential.new
  credential.public_key.format = "RSA_X509_PEM"
  credential.public_key.key = File.read(cert_path)

  device = Cloudiot::Device.new
  device.id = device_id
  device.credentials = [credential]

  # Create the device
  device = iot_client.create_project_location_registry_device parent, device

  puts "Device: #{device.id}"
  puts "\tBlocked: #{device.blocked}"
  puts "\tLast Event Time: #{device.last_event_time}"
  puts "\tLast State Time: #{device.last_state_time}"
  puts "\tName: #{device.name}"
  # [END iot_create_rsa_device]
end

$create_unauth_device = -> (project_id:, location_id:, registry_id:, device_id:) do
  # [START iot_create_unauth_device]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to create a device in"
  # device_id   = "The identifier of the device to create"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent = "projects/#{project_id}/locations/#{location_id}/registries/#{registry_id}"

  device = Cloudiot::Device.new
  device.id = device_id

  # Create the device
  device = iot_client.create_project_location_registry_device parent, device

  puts "Device: #{device.id}"
  puts "\tBlocked: #{device.blocked}"
  puts "\tLast Event Time: #{device.last_event_time}"
  puts "\tLast State Time: #{device.last_state_time}"
  puts "\tName: #{device.name}"
  # [END iot_create_unauth_device]
end

$delete_device = -> (project_id:, location_id:, registry_id:, device_id:) do
  # [START iot_delete_device]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to create a device in"
  # device_id   = "The identifier of the device to create"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent = "projects/#{project_id}/locations/#{location_id}"
  device_path = "#{parent}/registries/#{registry_id}/devices/#{device_id}"

  # Create the device
  res = iot_client.delete_project_location_registry_device(
    device_path
  )

  puts "Deleted device."
  # [END iot_delete_device]
end

$list_devices = -> (project_id:, location_id:, registry_id:) do
  # [START iot_list_devices]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to list devices from"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  resource = "projects/#{project_id}/locations/#{location_id}/registries/#{registry_id}"

  # List the devices in the provided region
  response = iot_client.list_project_location_registry_devices(
    resource
  )

  puts "Devices:"
  if response.devices && response.devices.any?
    response.devices.each { |device| puts "\t#{device.id}" }
  else
    puts "\tNo device registries found in this region for your project."
  end
  # [END iot_list_devices]
end

$get_device = -> (project_id:, location_id:, registry_id:, device_id:) do
  # [START iot_get_device]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to get a device from"
  # device_id   = "The identifier of the device to get"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent = "projects/#{project_id}/locations/#{location_id}"
  resource = "#{parent}/registries/#{registry_id}/devices/#{device_id}"

  # List the devices in the provided region
  device = iot_client.get_project_location_registry_device(
    resource
  )

  puts "Device: #{device.id}"
  puts "\tBlocked: #{device.blocked}"
  puts "\tLast Event Time: #{device.last_event_time}"
  puts "\tLast State Time: #{device.last_state_time}"
  puts "\tName: #{device.name}"
  puts "\tCertificate formats:"
  if device.credentials
    device.credentials.each { |cert| puts "\t\t#{cert.public_key.format}"}
  else
    puts "\t\tNo certificates for device"
  end
  # [END iot_get_device]
end

$get_device_configs = -> (project_id:, location_id:, registry_id:, device_id:) do
  # [START iot_get_device_configs]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to get a device from"
  # device_id   = "The identifier of the device to get configurations for"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent   = "projects/#{project_id}/locations/#{location_id}"
  resource = "#{parent}/registries/#{registry_id}/devices/#{device_id}"

  # List the configurations for the provided device
  configs = iot_client.list_project_location_registry_device_config_versions(
    resource
  )
  configs.device_configs.each do |config|
    puts "Version [#{config.version}]: #{config.binary_data}"
  end
  # [END iot_get_device_configs]
end

$get_device_states = -> (project_id:, location_id:, registry_id:, device_id:) do
  # [START iot_get_device_state]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to get device states from"
  # device_id   = "The identifier of the device to get states for"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent   = "projects/#{project_id}/locations/#{location_id}"
  resource = "#{parent}/registries/#{registry_id}/devices/#{device_id}"

  # List the configurations for the provided device
  res = iot_client.list_project_location_registry_device_states(
    resource
  )
  if res.device_states
    res.device_states.each do |state|
      puts "#{state.update_time}: #{state.binary_data}"
    end
  else
    puts "No state messages"
  end
  # [END iot_get_device_state]
end

$patch_es_device = -> (project_id:, location_id:, registry_id:, device_id:, cert_path:) do
  # [START iot_patch_es]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to create a device in"
  # device_id = "The identifier of the device to patch"
  # cert_path = "The path to the EC certificate"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent = "projects/#{project_id}/locations/#{location_id}/registries/#{registry_id}"
  path = "#{parent}/devices/#{device_id}"

  pubkey= Google::Apis::CloudiotV1::PublicKeyCredential.new
  pubkey.key = File.read(cert_path)
  pubkey.format = "ES256_PEM"

  cred = Google::Apis::CloudiotV1::DeviceCredential.new
  cred.public_key = pubkey

  device = Cloudiot::Device.new
  device.credentials = [cred]

  # Patch the device
  device = iot_client.patch_project_location_registry_device(
    path, device, update_mask: "credentials"
  )

  puts "Device: #{device.id}"
  puts "\tBlocked: #{device.blocked}"
  puts "\tLast Event Time: #{device.last_event_time}"
  puts "\tLast State Time: #{device.last_state_time}"
  puts "\tName: #{device.name}"
  puts "\tCertificate formats:"
  if device.credentials
    device.credentials.each { |cert| puts "\t\t#{cert.public_key.format}"}
  else
    puts "\t\tNo certificates for device"
  end
  # [END iot_patch_es]
end

$patch_rsa_device = -> (project_id:, location_id:, registry_id:, device_id:, cert_path:) do
  # [START iot_patch_rsa]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to create a device in"
  # device_id   = "The identifier of the device to patch"
  # cert_path   = "The path to the RSA certificate"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent = "projects/#{project_id}/locations/#{location_id}/registries/#{registry_id}"
  path   = "#{parent}/devices/#{device_id}"

  credential = Google::Apis::CloudiotV1::DeviceCredential.new
  credential.public_key = Google::Apis::CloudiotV1::PublicKeyCredential.new
  credential.public_key.format = "RSA_X509_PEM"
  credential.public_key.key = File.read(cert_path)

  device = Cloudiot::Device.new
  device.credentials = [credential]

  # Create the device
  device = iot_client.patch_project_location_registry_device(
    path, device, update_mask: "credentials"
  )

  puts "Device: #{device.id}"
  puts "\tBlocked: #{device.blocked}"
  puts "\tLast Event Time: #{device.last_event_time}"
  puts "\tLast State Time: #{device.last_state_time}"
  puts "\tName: #{device.name}"
  puts "\tCertificate formats:"
  if device.credentials
    device.credentials.each { |cert| puts "\t\t#{cert.public_key.format}"}
  else
    puts "\t\tNo certificates for device"
  end
  # [END iot_patch_rsa]
end

$send_device_config = -> (project_id:, location_id:, registry_id:, device_id:, data:) do
  # [START iot_set_device_config]
  # project_id  = "Your Google Cloud project ID"
  # location_id = "The Cloud region the registry is located in"
  # registry_id = "The registry to get a device from"
  # device_id   = "The identifier of the device to set configurations on"
  # data        = "The data, e.g. {fan: on} to send to the device"

  require "google/apis/cloudiot_v1"

  # Initialize the client and authenticate with the specified scope
  Cloudiot   = Google::Apis::CloudiotV1
  iot_client = Cloudiot::CloudIotService.new
  iot_client.authorization = Google::Auth.get_application_default(
    "https://www.googleapis.com/auth/cloud-platform"
  )

  # The resource name of the location associated with the project
  parent   = "projects/#{project_id}/locations/#{location_id}"
  resource = "#{parent}/registries/#{registry_id}/devices/#{device_id}"

  config = Cloudiot::DeviceConfig.new
  config.binary_data = data

  # Set configuration for the provided device
  iot_client.modify_cloud_to_device_config resource, config
  puts "Configuration updated!"
  # [END iot_set_device_config]
end

def run_sample arguments
  command    = arguments.shift
  project_id = ENV["GOOGLE_CLOUD_PROJECT"]

  case command
  # Registry management
  when "create_registry"
    $create_registry.call(
      project_id:   project_id,
      location_id:  arguments.shift,
      registry_id:  arguments.shift,
      pubsub_topic: arguments.shift,
    )
  when "delete_registry"
    $delete_registry.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
    )
  when "get_iam_policy"
    $get_iam_policy.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
    )
  when "get_registry"
    $get_registry.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
    )
  when "list_registries"
    $list_registries.call(
      project_id:  project_id,
      location_id: arguments.shift,
    )
  when "set_iam_policy"
    $set_iam_policy.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      member:      arguments.shift,
      role:        arguments.shift,
    )

  # Device management
  when "create_es_device"
    $create_es_device.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      device_id:   arguments.shift,
      cert_path:   arguments.shift,
    )
  when "create_rsa_device"
    $create_rsa_device.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      device_id:   arguments.shift,
      cert_path:   arguments.shift,
    )
  when "create_unauth_device"
    $create_unauth_device.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      device_id:   arguments.shift,
    )
  when "delete_device"
    $delete_device.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      device_id:   arguments.shift,
    )
  when "get_device"
    $get_device.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      device_id:   arguments.shift,
    )
  when "get_device_configs"
    $get_device_configs.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      device_id:   arguments.shift,
    )
  when "get_device_states"
    $get_device_states.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      device_id:   arguments.shift,
    )
  when "list_devices"
    $list_devices.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
    )
  when "patch_es_device"
    $patch_es_device.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      device_id:   arguments.shift,
      cert_path:   arguments.shift,
    )
  when "patch_rsa_device"
    $patch_rsa_device.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      device_id:   arguments.shift,
      cert_path:   arguments.shift,
    )
  when "send_configuration"
    $send_device_config.call(
      project_id:  project_id,
      location_id: arguments.shift,
      registry_id: arguments.shift,
      device_id:   arguments.shift,
      data:        arguments.shift,
    )
  else
    puts <<-usage
Usage: bundle exec ruby iot.rb [command] [arguments]

Registry Management Commands:
  create_registry <location> <registry_id> <pubsub_topic> Create a device registry.
  delete_registry <location> <registry_id> Delete a device registry.
  get_registry <location> <registry_id> Get the provided device registry.
  get_iam_policy <location> <registry_id> Get the IAM policy for a registry.
  list_registries <location> List the device registries in the provided region.
  set_iam_policy <location> <registry_id> <member> <role> Set the IAM policy for a registry to a single member / role.

Device Management Commands:
  create_es_device <location> <registry_id> <device_id> <public_key_path> Create a device with an ES256 credential
  create_rsa_device <location> <registry_id> <device_id> <public_key_path> Create a device with an RSA credential
  create_unauth_device <location> <registry_id> <device_id> Create a device without credentials
  delete_device <location> <registry_id> <device_id> Delete a device from a registry
  get_device <location> <registry_id> <device_id> Gets a device from a registry.
  get_device_configs <location> <registry_id> <device_id> List device configurations.
  get_device_states <location> <registry_id> <device_id> List device state history.
  list_devices <location> <registry_id> List the devices in the provided registry.
  patch_es_device <location> <registry_id> <device_id> <public_key_path> Patch a device with an ES256 credential
  patch_rsa_device <location> <registry_id> <device_id> <public_key_path> Patch a device with an RSA credential
  send_configuration <location> <registry_id> <device_id> <data> Set a device configuration.

Environment variables:
  GOOGLE_CLOUD_PROJECT must be set to your Google Cloud project ID
  GOOGLE_APPLICATION_CREDENTIALS set to the path to your JSON credentials
    usage
  end
end

if __FILE__ == $PROGRAM_NAME
  run_sample ARGV
end
