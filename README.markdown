# with_order

Provide ordering for tables, lists, etc.

This project follows [Semantic Versioning](http://semver.org/).

## Installation

    $ gem install with_order

If you're using Bundler, add this to your Gemfile:

    gem 'with_order', '~>0.2.0'

## Support

<table>
  <tr>
    <td><strong>Ruby</strong></td>
    <td>1.9</td>
  </tr>
  <tr>
    <td><strong>Rails</strong></td>
    <td>3.1</td>
  </tr>
  <tr>
    <td><strong>Database Framework</strong></td>
    <td>ActiveRecord</td>
  </tr>
</table>

## Usage

In your controller:

    @data = Data.with_order(params, default: :full_name, fields: {full_name: 'first_name ASC, last_name ASC'})

In your view:

    <th><%= link_with_order('ID', @data, :id) %></th>
    <th><%= link_with_order('Full Name', @data, :full_name) %></th>
    <th><%= link_with_order('Email', @data, :email) %></th>
