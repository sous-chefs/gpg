# Master default recipe that includes all test recipes in logical order

# Test 1: Generate GPG keys with various options
include_recipe 'test::test_generate'

# Test 2: Export keys to files
# include_recipe 'test::test_export'

# Test 3: Import keys from files and keyservers
# include_recipe 'test::test_import'

# Test 4: Delete keys (both public and secret keys)
# include_recipe 'test::test_delete'
