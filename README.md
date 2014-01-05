# strider-cd cookbook
This cookbook installs the Strider CD software according to the documentation found here: https://github.com/Strider-CD/strider#general-requirements

# Requirements

#### packages
- NodeJS
- MongoDB

# Platform

CentOS, Red Hat, Fedora

Tested on:

CentOS 6.5

# Cookbooks

- yum
- yum-epel
- build-essential

# Usage

#### strider-cd::default
Just include `strider-cd` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[strider-cd]"
  ]
}
```

# Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

# Author

Author:: Michael Goetz (<mpgoetz@gmail.com>)
