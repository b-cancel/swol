/*
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: cardRadius,
                topRight: cardRadius,
                bottomLeft: cardRadius,
                bottomRight: cardRadius,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 24,
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.red,
                      padding: EdgeInsets.all(16),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "9",
                          style: TextStyle(
                            fontSize: 128,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 6.0,
                            ),
                            child: Icon(FontAwesomeIcons.dumbbell),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(Icons.repeat),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.blue,
                      child: Center(
                        child: Container(
                          color: Colors.red,
                          child: 
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          */

/*
Container(
            color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Container(
                color: Colors.yellow,
                height: 24,
                width: 48,
                child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                //only ever allow 1 line
                                minLines: 1,
                                maxLines: 1,
                                expands: false,
                                //only allow 3 characters because nobody can do 1,000 reps
                                maxLength: 3,
                                maxLengthEnforced: true,
                                //keyboard stuff
                                keyboardAppearance: Brightness.dark,
                                keyboardType: TextInputType.numberWithOptions(
                                  signed: false, 
                                  decimal: false,
                                ),
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                
                                toolbarOptions: ToolbarOptions(
                                  copy: true,
                                  cut: true,
                                  paste: true,
                                  selectAll: true,
                                ),
                                
                                //don't help user at all
                                autocorrect: false,
                                enableSuggestions: false,
                                //decoration
                                style: GoogleFonts.robotoMono(),
                                decoration: InputDecoration(
                                  counterText: "", //small as possible
                                  border: InputBorder.none,
                                ),
                              ),
              ),
            ),
          ),
*/