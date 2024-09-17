
#!/bin/bash


validate_component() {
    case "$1" in
        INGESTOR|JOINER|WRANGLER|VALIDATOR) return 0 ;;
        *) echo "Invalid Component Name. Choose from INGESTOR, JOINER, WRANGLER, VALIDATOR."; return 1 ;;
    esac
}


validate_scale() {
    case "$1" in
        MID|HIGH|LOW) return 0 ;;
        *) echo "Invalid Scale. Choose from MID, HIGH, LOW."; return 1 ;;
    esac
}


validate_view() {
    case "$1" in
        Auction|Bid) return 0 ;;
        *) echo "Invalid View. Choose from Auction, Bid."; return 1 ;;
    esac
}


validate_count() {
    if [[ "$1" =~ ^[0-9]$ ]]; then
        return 0
    else
        echo "Invalid Count. Enter a single digit number.";
        return 1
    fi
}

read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " COMPONENT
while ! validate_component "$COMPONENT"; do
    read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " COMPONENT
done

read -p "Enter Scale [MID/HIGH/LOW]: " SCALE
while ! validate_scale "$SCALE"; do
    read -p "Enter Scale [MID/HIGH/LOW]: " SCALE
done

read -p "Enter View [Auction/Bid]: " VIEW
while ! validate_view "$VIEW"; do
    read -p "Enter View [Auction/Bid]: " VIEW
done

read -p "Enter Count [single digit number]: " COUNT
while ! validate_count "$COUNT"; do
    read -p "Enter Count [single digit number]: " COUNT
done

if [ "$VIEW" == "Auction" ]; then
    VIEW_PREFIX="vdopia-etl"
elif [ "$VIEW" == "Bid" ]; then
    VIEW_PREFIX="vdopia-bid"
fi

NEW_LINE="$VIEW ; $SCALE ; $COMPONENT ; ETL ; $VIEW_PREFIX= $COUNT"

FILE="sys.conf"

cp "$FILE" "$FILE.bak"

sed -i "/^[^;]* ; $SCALE ; $COMPONENT ; ETL ; $VIEW_PREFIX= /c\\ $NEW_LINE" "$FILE"



echo "Configuration updated successfully."

