package utils

import (
	"std"
	"strings"
)

func GetCaller() std.Address {
	return std.PreviousRealm().Address()
}

func Parse(fullpath string) (string, map[string]string) {
	parts := strings.Split(fullpath, ":")
	if len(parts) == 2 {
		return parts[1], map[string]string{}
	}
	return "", map[string]string{}
}
