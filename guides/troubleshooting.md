# Troubleshooting / Common Errors

This section contains help with common errors that may arise while using Tamnoon.

## Jason.Encoder must be explicitly implemented

This error may arise while using the `Tamnoon.MethodManager.defmethod/2` macro. Notably, this will happen when the value that the method handler returns to the client is not able to be decoded by `m:Jason`. 
To fix this, always return maps to the client. For example, this will NOT work:

```
defmethod :my_method do
  # Do something...
  {{key, value}, state}
end
```

This WILL work:

```
defmethod :my_method do
  # Do something...
  {%{key => value}, state}
end
```