---
title: "Code Snippet and Image"
date: 2024-01-10T12:14:47Z
draft: false
summary: A compact example of code highlighting and local figure handling.
tags: ["code", "syntax highlighting", "images"]
categories: ["theme design"]
images:
- posts/code-image/example.svg
---

Code blocks should be readable without turning the page into a dashboard. The theme uses Chroma classes when configured, with colors that work against the bundled dark code background.

```java
// A Java program to demonstrate random number generation
// using java.util.Random;
import java.util.Random;

public class generateRandom{

	public static void main(String args[])
	{
		// create instance of Random class
		Random rand = new Random();

		// Generate random integers in range 0 to 999
		int rand_int1 = rand.nextInt(1000);
		int rand_int2 = rand.nextInt(1000);

		// Print random integers
		System.out.println("Random Integers: "+rand_int1);
		System.out.println("Random Integers: "+rand_int2);

		// Generate Random doubles
		double rand_dub1 = rand.nextDouble();
		double rand_dub2 = rand.nextDouble();

		// Print random doubles
		System.out.println("Random Doubles: "+rand_dub1);
		System.out.println("Random Doubles: "+rand_dub2);
	}
}
```

Inline code such as `hugo server` should also feel integrated with the surrounding sentence.

{{< figure src="example.svg" alt="A local illustration of code lines in a terminal window" caption="A local SVG page resource used as both article content and Open Graph image." >}}

Images stay within the content column by default, with captions styled as quiet supporting text.
