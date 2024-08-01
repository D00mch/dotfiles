package main

import (
	"fmt"
	"github.com/go-vgo/robotgo"
	"os/exec"
)

func RunShell(arg ...string) error {
	cmd := exec.Command("sh", arg...)
	stdout, err := cmd.Output()
	if err != nil {
		fmt.Println(err.Error())
		return err
	}
	fmt.Println(stdout)
	return nil
}

func DarkModeToggle() {
	cmd := "osascript -e 'tell application \"System Events\"" +
		"to tell appearance preferences to set dark mode to not dark mode'"
	RunShell("-c", cmd)
}

func OpenApp(appName string) error {
	return RunShell("-c", "open -a "+appName)
}

func ChromeDarkModeToggle() {
	err := OpenApp("Google\\ Chrome.app")
	if err != nil {
		return
	}
	err = robotgo.KeyTap("d", "alt", "shift")
	if err != nil {
		fmt.Println(err.Error())
		return
	}
}

func main() {
	DarkModeToggle()
	ChromeDarkModeToggle()
}
