{lib}: {
  reverseProxy = {
    address,
    copyResponseHeaders ? true,
  }: ''
    reverse_proxy ${address}
    ${lib.optionalString copyResponseHeaders "copy_response_headers"}
  '';

  redirect = address: "redir ${address}";
}
