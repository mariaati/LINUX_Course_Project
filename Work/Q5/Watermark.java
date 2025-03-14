import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;

public class Watermark { //ensuring the correct num of arg is provided
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: java Watermark <folder_path> <watermark_text>");
            System.exit(1);
        }

	//folder path and watermark txt from the terminal
        String folderPath = args[0];
        String watermarkText = args[1];

	//creatin a file object
        File folder = new File(folderPath);
        if (!folder.exists() || !folder.isDirectory()) {
            System.out.println("invalid folder path!!");
            System.exit(1);
        }

	//retrieve all the png imgs
        File[] files = folder.listFiles((dir, name) -> name.toLowerCase().endsWith(".png"));

        if (files == null || files.length == 0) {
            System.out.println("no png imgs found in the folder");
            System.exit(1);
        }

	//run through every img
        for (File file : files) {
            try {
                BufferedImage image = ImageIO.read(file);//readin the img
                Graphics2D g2d = image.createGraphics();
                g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);//for smoother txt
                Font font = new Font("Arial", Font.BOLD, 20);//set font and calculate center position
                g2d.setFont(font);
                FontMetrics fm = g2d.getFontMetrics();//txt dimensions
                int textWidth = fm.stringWidth(watermarkText);
                int textHeight = fm.getHeight();
                int x = (image.getWidth() - textWidth) / 2;
                int y = (image.getHeight() / 2) + (textHeight / 4);

		//add semi transperent bg for visibility
                g2d.setColor(new Color(0, 0, 0, 100));  //black bg
                g2d.fillRect(x - 10, y - textHeight + 10, textWidth + 20, textHeight + 10);

                //draw the watermark in red
                g2d.setColor(new Color(255, 0, 0, 180));  //red txt
                g2d.drawString(watermarkText, x, y);
                g2d.dispose();//clean up the graphics resources

                //save the watermark
                File output = new File(folderPath + "/watermarked_" + file.getName());
                ImageIO.write(image, "png", output);

                System.out.println("watermarked: " + output.getName());

            } catch (IOException e) {
                System.out.println("failed to process " + file.getName());
                e.printStackTrace();
            }
        }

        System.out.println("Watermarking completed!");
    }
}
