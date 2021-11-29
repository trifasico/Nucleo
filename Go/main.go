package main

import (
	"context"
	"fmt"
	"log"

	firebase "firebase.google.com/go"

	"google.golang.org/api/option"
)

//var Pessoas = [[]]string;

func main() {
	//var selection int = 1
	print("Connecting.............  \n\n\n")
	ctx := context.Background()
	opt := option.WithCredentialsFile("/Users/nandoribeiro/Documents/Coding/Go/Nucleo/appneeeicum-firebase-adminsdk-nxpvm-03eb1d645a.json")
	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		print(fmt.Errorf("error initializing app: %v", err))
	} else {
		print("------------ Sucess Login ------------  \n\n\n")
	}
	client, err := app.Firestore(ctx)
	if err != nil {
		log.Fatalln(err)
	}

	/*for selection != 0 {
		ShowMenu(&selection)
	}*/

	//excel()
	//ShowAllPeople(ctx, client, "Logins")
	PeopleRead(ctx, client, "Logins")
	for i := 0; i < len(Logins); i++ {
		for j := 0; j < len(Logins[i].posts); j++ {
			if (Logins[i].posts[j] == 4) {
				fmt.Println(Logins[i].mail)
			}
		}
	}
	/*for selection != 0 {
		ShowMenu(&selection)
	}*/
	KitsRead(ctx, client, "Kits")
	//excelPeople(Logins, Kits)

	Kits2Excel(Kits, Logins)

}
