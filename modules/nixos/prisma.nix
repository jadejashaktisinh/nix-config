{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.openssl                 # Ensure OpenSSL is installed system-wide
    pkgs.prisma-engines_7       # Use explicit Prisma 7 core engines
    pkgs.prisma_7               # Use explicit Prisma 7 global CLI tool
  ];

  environment.sessionVariables = {
    # Fixes the OpenSSL missing warning on NixOS
    PRISMA_CLI_QUERY_ENGINE_TYPE = "binary";
    PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING_DEPENDENCIES = "1";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

    # Point session paths cleanly to the V7 engine files
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines_7}/bin/schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines_7}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines_7}/lib/libquery_engine.node";
    PRISMA_FMT_BINARY = "${pkgs.prisma-engines_7}/bin/prisma-fmt";
  };
}
